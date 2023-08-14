# Working sets
[Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/memory/working-set)

Task Manager reports private working set as "Memory".

## Querying
- [GetProcessMemoryInfo](https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-getprocessmemoryinfo)

  只能获取 `WorkingSetSize` 和 `PeakWorkingSetSize`。
- [QueryWorkingSet](https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-queryworkingset)
- [QueryWorkingSetEx](https://learn.microsoft.com/en-us/windows/win32/api/psapi/nf-psapi-queryworkingsetex)

  必须指定地址，而不能自动枚举。

Counting private working set:
```rust
use windows::Win32::System::{
    Threading::{GetCurrentProcess},
    ProcessStatus::{QueryWorkingSet, PSAPI_WORKING_SET_BLOCK},
};

pub fn get_process_private_working_set() -> usize {
    let process = unsafe { GetCurrentProcess() };
    
    const LEN: usize = (4 << 30) / 4096;
    #[repr(C)]
    struct PSAPI_WORKING_SET_INFORMATION {
        pub NumberOfEntries: usize,
        pub WorkingSetInfo: [PSAPI_WORKING_SET_BLOCK; LEN],
    };
    let size = std::mem::size_of::<usize>() + LEN * std::mem::size_of::<PSAPI_WORKING_SET_BLOCK>();
    // Box::new(PSAPI_WORKING_SET_INFORMATION { ... }) will cause stack overflow
    // (this issue exists from 2015)
    let mut buf = vec![0u8; size].into_boxed_slice();
    let buf = unsafe { &mut *(buf.as_mut_ptr() as *mut PSAPI_WORKING_SET_INFORMATION) };
    if unsafe {
        QueryWorkingSet(
            process,
            buf as *mut _ as *mut _,
            size as u32
        )
    }.as_bool() {
        let mut private_ws = 0;
        // iter().take(buf.NumberOfEntries) will cause access violation.
        for i in 0..buf.NumberOfEntries {
            // struct {
            //   ULONG_PTR Protection : 5;
            //   ULONG_PTR ShareCount : 3;
            //   ULONG_PTR Shared : 1;
            //   ULONG_PTR Reserved : 3;
            //   ULONG_PTR VirtualPage : 52;
            // };
            let flags = unsafe { buf.WorkingSetInfo[i].Flags };
            // println!("i: {}, addr: {:X}, flags: {:X}", i, flags & !0xFFF, flags & 0xFFF);
            if flags & 0x100 == 0 {
                private_ws += 4096;
            }
        }
        private_ws
    } else {
        0
    }
}
```