# [Message Queues](https://learn.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues)
The system maintains a single system message queue and one thread-specific message queue for each GUI thread. Whenever the user moves the mouse, clicks the mouse buttons, or types on the keyboard, the device driver for the mouse or keyboard converts the input into messages and places them in the system message queue. The system removes the messages, one at a time, from the system message queue, examines them to determine the destination window, and then posts them to the message queue of the thread that created the destination window. A thread's message queue receives all mouse and keyboard messages for the windows created by the thread. The thread removes messages from its queue and directs the system to send them to the appropriate window procedure for processing.

[Inside the Windows Messaging System | Dr Dobb's](https://www.drdobbs.com/windows/inside-the-windows-messaging-system/184408943) ([Hacker News](https://news.ycombinator.com/item?id=20179944))

## Message routing
Message → Foreground → Active

> Windows uses two methods to route messages to a window procedure: (1) posting messages to a first-in, first-out queue called a *message queue*, which is a system-defined memory object that temporarily stores messages; and (2) sending messages directly to a window procedure. Messages posted to a message queue are called *queued messages*. They are primarily the result of user input via the mouse or keyboard, such as `WM_MOUSEMOVE`, `WM_LBUTTONDOWN`, `WM_KEYDOWN`, and `WM_CHAR` messages. Other queued messages include the timer, paint, and quit messages: `WM_TIMER`, `WM_PAINT`, and `WM_QUIT`. Most other messages are sent directly to a window procedure and are called, surprisingly enough, *nonqueued messages*.

> Windows NT maintains a single system-message queue and any number of thread-message queues, one for each thread. Whenever the user moves the mouse, clicks the mouse buttons, or types at the keyboard, the device driver for the mouse or keyboard converts the input into messages and places them in the system-message queue. Windows removes the messages, one at a time, from the system-message queue, examines them to determine the destination window, and then posts them to the message queue of the thread that created the destination window. A thread's message queue receives all mouse and keyboard messages for the windows created by the thread. The thread removes messages from its queue and directs Windows NT to send them to the appropriate window procedure for processing. The system posts a message to a thread's message queue by filling an **MSG** structure and then copying it to the message queue. Information in the **MSG** structure includes the handle of the window for which the message is intended, the message identifier, the two message parameters, the message time, and the mouse-cursor position. A thread can post a message to its own message queue or to the queue of another thread by using the **PostMessage** or **PostThreadMessage** function.

[DispatchMessage function (winuser.h) - Win32 apps | Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-dispatchmessage)
> DispatchMessage() is straightforward, except for a few things. At the start of the code, there's special handling for WM_TIMER and WM_SYSTIMER messages. If the lParam field of the message is nonzero, a user-supplied callback is called instead of the standard window procedure. The SDK documentation for SetTimer() describes how to use timers.
>
> Also, DispatchMessage() handles "bad" programs that don't call BeginPaint() in their WM_PAINT handler. Apparently, Microsoft feels that it's enough of a problem that DispatchMessage() always checks if BeginPaint() was called by the app's message handler. If the program didn't call BeginPaint(), Dispatch Message() goes ahead and does some default painting to correct the situation (and whine at you with a debug message if you're running the debug version of Windows).
>
> Lastly, you might notice that, before your program's window procedure is called, DS is set to the hInstance of the application. This compensates for applications that fail to export their callback functions. Under Windows 3.0, this may result in a GP fault (due to an invalid DS) when your window procedure gets called. With Windows 3.1, some people claim you no longer have to export functions or call MakeProcInstance(). This may or may not be sound advice, but Microsoft seems to feel that setting DS is a worthwhile activity for DispatchMessage().

```c
    LPMSG lpMsg    // ptr to passed-in message, used as scratch variable.
    if ( (msg != WM_TIMER) && (msg != WM_SYSTIMER) )
        goto handle_normally
    if ( msg.lParam == 0 )
        goto handle_normally
    GetTickCount()
    push msg parameters on stack
    lpMsg = msg.lParam  // Timer function callback address
    AX = SS     // Something with MakeProcInstance thunk???
    goto call_function
handle_normally:
    if ( msg.hwnd == 0 )
        return;
    push msg parameters on stack
    if ( msg.msg == WM_PAINT )
        set "paint" flag in WND structure
    lpMsg = Window proc address // stored in WND data structure;
                                // pointed to by msg.hwnd
    AX = hInstance from WND structure   // For use by MakeProcInstance() thunks
call_function:
    ES = DS = SS    // Set all segment registers to hInstance of application
    call [lpMsg]    // Call the window proceedure (or timer callback fn).
                    // lpMsg is now used to store the address of window
                    // function (or timer callback function) to be called
    if ( msg.msg != WM_PAINT )
        goto DispatchMessage_done
    // Check for destroyed window
    if ( ! IsWindow(msg.msg) )
        goto DispatchMessage_done
    if ( "paint" flag in wnd structure still set )
        goto No_BeginPaint
DispatchMessage_done:
    return
No_BeginPaint:
    Display debugging message "Missing BeginPaint..."
    Call DoSyncPaint() to handle the painting correctly
    goto DispatchMessage_done
```

[windows - Is calling DispatchMessage in win32 programs necessary? - Stack Overflow](https://stackoverflow.com/questions/12282270/is-calling-dispatchmessage-in-win32-programs-necessary)
> You call `DispatchMessage` to have the message delivered to proper window, to its "window proc". You think you have one window only, but is it really the only one? `COM` will create helper windows, other subsystems might create helper hidden windows as well, who is going to deliver messages posted to shared message queue and addressed to those windows. Without having to think a lot about these details you have API to dispatch them. And you have to do it because those subsystems are relying on presence of message pump.

[Why DispatchMessage() ?](https://comp.os.ms-windows.programmer.win32.narkive.com/onvrvxhN/why-dispatchmessage)

## Multiple message queues
[Multiple Threads in the User Interface | Microsoft Learn](https://learn.microsoft.com/en-us/previous-versions/ms810439(v=msdn.10)?redirectedfrom=MSDN)
> Applications with multiple threads must include a message loop in each thread that creates a window. The message loop and window procedure for a window must be processed by the thread that created the window. If the message loop does not reside in the same thread that created the window, the **DispatchMessage** function will not get messages for the window. As a result, the window will appear but won't show activation and won't repaint, be moved, receive mouse messages, or generally work as you expect it to.

See also [cross-process/thread child windows](../Windows/Types/Child.md#cross-processthread).

[c# - In WinForms, Is More than One Thread Possible in the UI? - Stack Overflow](https://stackoverflow.com/questions/21728740/in-winforms-is-more-than-one-thread-possible-in-the-ui)

## Implementation
```cpp
// Windows XP SP1

/*
 * Message Queue structure.
 *
 * Note, if you need to add a WORD sized value,
 * do so after xbtnDblClk.
 */
typedef struct tagQ {
    MLIST       mlInput;            // raw mouse and key message list.

    PTHREADINFO ptiSysLock;         // Thread currently allowed to process input
    ULONG_PTR    idSysLock;          // Last message removed or to be removed before unlocking
    ULONG_PTR    idSysPeek;          // Last message peeked

    PTHREADINFO ptiMouse;           // Last thread to get mouse msg.
    PTHREADINFO ptiKeyboard;

    PWND        spwndCapture;
    PWND        spwndFocus;
    PWND        spwndActive;
    PWND        spwndActivePrev;

    UINT        codeCapture;        // type of captue. See *_CAP* defines in this file
    UINT        msgDblClk;          // last mouse down message removed
    WORD        xbtnDblClk;         // last xbutton down
    DWORD       timeDblClk;         // max time for next button down to be taken as double click
    HWND        hwndDblClk;         // window that got last button down
    POINT       ptDblClk;           // last button down position. See SYSMET(C?DOUBLECLK)

    BYTE        afKeyRecentDown[CBKEYSTATERECENTDOWN];
    BYTE        afKeyState[CBKEYSTATE];

    CARET       caret;

    PCURSOR     spcurCurrent;
    int         iCursorLevel;       // show/hide count. < 0 if the cursor is not visible

    DWORD       QF_flags;            // QF_ flags go here

    USHORT      cThreads;            // Count of threads using this queue
    USHORT      cLockCount;          // Count of threads that don't want this queue freed

    UINT        msgJournal;         // See SetJournalTimer. Journal message to be delivered when timer goes off
    LONG_PTR    ExtraInfo;          // Extra info for last qmsg read. See GetMessageExtraInfo
} Q;

/*
 * Queue Variables
 */
PQ gpqForeground;
PQ gpqForegroundPrev;
PQ gpqCursor;
```
