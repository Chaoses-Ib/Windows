# [Component Object Model](https://docs.microsoft.com/en-us/windows/win32/com/component-object-model--com--portal)
COM is a platform-independent, distributed, object-oriented system for creating binary software components that can interact.

## Bindings
### C++
- [Roapi.h header - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/roapi/)

  `runtimeobject.lib`
  - [How to declare and link to RoInitialize,RoUninitialize,RoGetActivationFactory and HSTRING Functions in Mingw Gcc - Stack Overflow](https://stackoverflow.com/questions/16466641/how-to-declare-and-link-to-roinitialize-rouninitialize-rogetactivationfactory-an)

### Rust
- [windows-interface](https://docs.rs/windows-interface/)
- [windows-implement](https://docs.rs/windows-implement/)

```rust
#[interface("094d70d6-5202-44b8-abb8-43860da5aca2")]
unsafe trait IValue: IUnknown {
    fn GetValue(&self, value: *mut i32) -> HRESULT;
}

#[implement(IValue)]
struct Value(i32);

impl IValue_Impl for Value {
    unsafe fn GetValue(&self, value: *mut i32) -> HRESULT {
        *value = self.0;
        HRESULT(0)
    }
}

fn main() {
    let rust_instance = Value(123);
    let com_object: IValue = rust_instance.into();
    // You can now call interface methods on com_object.
}
```

`IInterface` is `NonNull<c_void>` under the hood.
- Use `IInterface::from_raw()` to convert `*mut c_void` to `IInterface`.

## Activation
COM has three activation models that can be used to bring objects into memory to allow method calls be invoked[^essential]:
- Inprocess
- Out of process
- Remote host

### Registration-free activation
- [Activation contexts](https://docs.microsoft.com/en-us/windows/win32/sbscs/creating-registration-free-com-objects)
  - [Registration-Free Activation of COM Components: A Walkthrough | Microsoft Docs](https://docs.microsoft.com/en-us/previous-versions/dotnet/articles/ms973913(v=msdn.10)?redirectedfrom=MSDN)
- [Assembly manifests](https://docs.microsoft.com/en-us/windows/win32/sbscs/assembly-manifests)
  - [Registration-Free Activation of COM Components: A Walkthrough | Microsoft Docs](https://docs.microsoft.com/en-us/previous-versions/dotnet/articles/ms973913(v=msdn.10)?redirectedfrom=MSDN)
  - [Using COM without registration – Developex blog](https://developex.com/blog/using-com-without-registration/)
- [Registry virtualization](../../../Kernel/Configuration/Registry/README.md#virtualization)
  - [Using COM without registration – Developex blog](https://developex.com/blog/using-com-without-registration/)
- Call `DllGetClassObject()`
  
  > Make sure you're in the correct apartment before calling `DllGetClassObject()`. Even so, you won't get marshaling for the specific object model interfaces. Even if the C++ COM objects implement `IMarshal` or `IProvideClassInfo` themselves, you'll need to do the same if you're the one providing objects that implement any of those interfaces (e.g. event dispinterfaces). For these reasons and many other, this is bad practice.[^regfree-so]

  - [Using COM Without Registration - CodeProject](https://www.codeproject.com/Tips/1037909/Using-COM-Without-Registration)

[^regfree-so]: [c++ - Use COM Object from DLL without register - Stack Overflow](https://stackoverflow.com/questions/11088227/use-com-object-from-dll-without-register) 

## Hijacking
- [COM Hijacking for Persistence – Cyber Struggle](https://cyberstruggle.org/com-hijacking-for-persistence/)
- [Persistence – COM Hijacking – Penetration Testing Lab](https://pentestlab.blog/2020/05/20/persistence-com-hijacking/)

[^essential]: *Essential COM*