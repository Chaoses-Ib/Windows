# API
1. Win16 (C-style functions)
2. Microsoft Foundation Class Library
3. Object Linking and Embedding
4. [Component Object Model](COM/README.md)
5. [Win32](Win32/README.md) (C-style functions and COM)
6. [→.NET](https://github.com/Chaoses-Ib/.NET)
7. WinFX
8. [Windows Runtime](WinRT/README.md)
9. [Windows App SDK](AppSDK/README.md)

![](https://cdn.arstechnica.net/wp-content/uploads/2012/10/winrt.png)

[Turning to the past to power Windows’ future: An in-depth look at WinRT | Ars Technica](https://arstechnica.com/features/2012/10/windows-8-and-winrt-everything-old-is-new-again/)

## Windows SDK
[Wikipedia](https://en.wikipedia.org/wiki/Microsoft_Windows_SDK)

- VS 2019: 10.0.16299~10.0.22000
- VS 2022: 10.0.18362~10.0.26100

[→Windows Driver Kit](../../Kernel/Drivers/README.md#windows-driver-kit)

## Win32 metadata
[Making Win32 APIs More Accessible to More Languages - Windows Developer Blog](https://blogs.windows.com/windowsdeveloper/2021/01/21/making-win32-apis-more-accessible-to-more-languages/)

[win32metadata: Tooling to generate metadata for Win32 APIs in the Windows SDK.](https://github.com/microsoft/win32metadata)
- [C#/Win32 P/Invoke Source Generator](https://github.com/microsoft/CsWin32)
- [Rust for Windows](https://github.com/microsoft/windows-rs)
- [The C++ Windows SDK projection](https://github.com/microsoft/cppwin32)

## API sets
Windows 8+

## Bindings
### .NET
- [C#/Win32 P/Invoke Source Generator](https://github.com/microsoft/CsWin32)
- [P/Invoke: A library containing all P/Invoke code so you don't have to import it every time.](https://github.com/dotnet/pinvoke)
- [pinvoke.net: the interop wiki!](https://pinvoke.net/)
- [WinApi: A simple, direct, ultra-thin CLR library for high-performance Win32 Native Interop](https://github.com/prasannavl/WinApi)

### Rust
- [windows-rs: Rust for Windows](#windows-rs)

- [winapi-rs: Rust bindings to Windows API](https://github.com/retep998/winapi-rs) (discontinued)

  [What's the difference between the winapi and windows-sys crates in Rust? : rust](https://www.reddit.com/r/rust/comments/12b6c5u/whats_the_difference_between_the_winapi_and/)

- [WinSafe: Windows API and GUI in safe, idiomatic Rust.](https://github.com/rodrigocfd/winsafe)
- [rs-winapi2: Microsoft Windows user-mode API access with clean Rust types.](https://github.com/MauriceKayser/rs-winapi2) (discontinued)
- [winwrap: Rust-friendly Windows API wrappers](https://github.com/takubokudori/winwrap)

#### [windows-rs](https://github.com/microsoft/windows-rs)
- [windows](https://microsoft.github.io/windows-docs-rs/doc/windows/)
  - [Feature search](https://microsoft.github.io/windows-rs/features/#/master)
    - Only the first 50 results are shown.
- [windows-sys](https://docs.rs/windows-sys/)
- [windows-result](https://docs.rs/windows-result/)
- [windows-registry](https://docs.rs/windows-registry/)

[Getting Started with Rust](https://kennykerr.ca/rust-getting-started/index.html)

- [RAII type for HANDLES? · Issue #2222 · microsoft/windows-rs](https://github.com/microsoft/windows-rs/issues/2222)

v0.48 → v0.56:
- `BOOL` → `Result<()>`
- Some pointers → references

##### Error handling
- `windows::Win32::Foundation::WIN32_ERROR`
  - HRESULT: `to_hresult()`
  - Result: `ok()`
  - Error: `from_error(error: &windows_core::Error) -> Option<Self>`
- `windows_result::HRESULT`
  - `HRESULT(i32)`
  - WIN32_ERROR: `from_win32(error: u32)`
  - `from_nt(error: i32)`
  - Result: `from(result: Result<T>)`, `from(error: Error)`
- `windows_result::{Result, Error}`
  - `NonZeroI32`
  - WIN32_ERROR: `from_win32()`

    `Error::from_win32` will convert the error code to `HRESULT` `0x8007____`.
    ```rust
    if error == 0 { 0 } else { (error & 0x0000_FFFF) | (7 << 16) | 0x8000_0000 }
    ```

    <details>
    This means code like this will be silently broken:
    ```rust
    match Func().ok() {
        Ok(_) => (),
        Err(e) => match e.code() {
          // Never match
          ERROR_INVALID_FUNCTION => todo!(),
          // Always match
          _ => panic!(),
        }
    }
    ```

    To convert it back, use `WIN32_ERROR::from_error`. For example:
    ```rust
    match Func().ok() {
        Ok(_) => (),
        Err(e) => match WIN32_ERROR::from_error(e).unwrap_or_default() {
          ERROR_INVALID_FUNCTION => todo!(),
          _ => panic!(),
        }
    }
    ```

    However, `HRESULT` and `WIN32_ERROR` cannot be directly compared anymore.
    </details>

  - `from(code: HRESULT)`/`from_hresult(code: HRESULT)`, `code(&self) -> HRESULT`
  - `from(from: std::io::Error)`, ...

- Matching errors
  - `WIN32_ERROR`
    ```rust
    match unsafe { GetLastError() } {
        NO_ERROR => (),
        ERROR_INVALID_FUNCTION => todo!(),
        _ => panic!(),
    }
    ```
  - `Error`
    ```rust
    match windows::core::Error::from_win32() {
        e if e == NO_ERROR.into() => (),
        e if e == ERROR_INVALID_FUNCTION.into() => todo!(),
        _ => panic!(),
    }
    ```
  - `WIN32_ERROR` from `Error`
    ```rust
    match WIN32_ERROR::from_error(&windows::core::Error::from_win32()).unwrap() {
        NO_ERROR => (),
        ERROR_INVALID_FUNCTION => todo!(),
        _ => panic!(),
    }
    ```
    ```rust
    match WIN32_ERROR::from_error(&windows::core::Error::from_win32()) {
        Some(e) => match e {
            NO_ERROR => (),
            ERROR_INVALID_FUNCTION => todo!(),
            _ => panic!(),
        },
        None => panic!(),
    }
    ```
- Why some API return `Result<()>`, some return `HRESULT`?