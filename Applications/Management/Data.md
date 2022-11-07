# Application Data
Environment variable | Directory path | Description[^SpecialFolder]
--- | --- | ---
%APPDATA% | `C:\Users\<Username>\AppData\Roaming` | The directory that serves as a common repository for application-specific data for the current roaming user. A roaming user works on more than one computer on a network. A roaming user's profile is kept on a server on the network and is loaded onto a system when the user logs on.
%LOCALAPPDATA% | `C:\Users\<Username>\AppData\Local` | The directory that serves as a common repository for application-specific data that is used by the current, non-roaming user.
%LOCALAPPDATA%Low | `C:\Users\<Username>\AppData\LocalLow` |
%TEMP%<br />%TMP% | `C:\Users\<Username>\AppData\Local\Temp`
%ALLUSERSPROFILE%<br />%ProgramData% | `C:\ProgramData` | The directory that serves as a common repository for application-specific data that is used by all users.

> Any data in the Roaming folder would follow a user if they logged into another domain-connected PC at their company. Local stores data only on one PC. It's up to the developers what goes where, but generally data in the Local folder is machine specific or too large to sync. LocalLow stays on one PC like Local, but has a lower level of access. It's not too common now. One example is Internet Explorer's Protected Mode.[^muo]

[^SpecialFolder]: [Environment.SpecialFolder Enum (System) | Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.environment.specialfolder?view=net-6.0)
[^muo]: [What's the Difference Between AppData Roaming and Local?](https://www.makeuseof.com/tag/appdata-roaming-vs-local/)