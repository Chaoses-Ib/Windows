# Sleeping
## ping
To wait 10 seconds[^ping-so]:
```cmd
ping 127.255.255.255 -n 1 -w 10000 >nul
```
or:
```cmd
ping localhost -n 11 >nul
```

[^ping-so]: [python - Sleeping in a batch file - Stack Overflow](https://stackoverflow.com/questions/166044/sleeping-in-a-batch-file/21941058#21941058)

## timeout (Windows 7 and later)
```cmd
TIMEOUT [/T] timeout [/NOBREAK]

Description:
    This utility accepts a timeout parameter to wait for the specified
    time period (in seconds) or until any key is pressed. It also
    accepts a parameter to ignore the key press.

Parameter List:
    /T        timeout       Specifies the number of seconds to wait.
                            Valid range is -1 to 99999 seconds.

    /NOBREAK                Ignore key presses and wait specified time.

    /?                      Displays this help message.

NOTE: A timeout value of -1 means to wait indefinitely for a key press.

Examples:
    TIMEOUT /?
    TIMEOUT /T 10
    TIMEOUT /T 300 /NOBREAK
    TIMEOUT /T -1
```
> Timeout is poorly implemented. If you do a `timeout 1`, it will wait until the "next second", which could occur in .1 seconds. For 5 seconds or more, it may not be a big deal, but for a 1 second delay it works poorly.[^timeout-so]

[^timeout-so]: [timeout - How to sleep for five seconds in a batch file/cmd - Stack Overflow](https://stackoverflow.com/questions/1672338/how-to-sleep-for-five-seconds-in-a-batch-file-cmd/1672375#1672375)