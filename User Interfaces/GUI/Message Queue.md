# [Message Queue](https://learn.microsoft.com/en-us/windows/win32/winmsg/about-messages-and-message-queues)
The system maintains a single system message queue and one thread-specific message queue for each GUI thread. Whenever the user moves the mouse, clicks the mouse buttons, or types on the keyboard, the device driver for the mouse or keyboard converts the input into messages and places them in the system message queue. The system removes the messages, one at a time, from the system message queue, examines them to determine the destination window, and then posts them to the message queue of the thread that created the destination window. A thread's message queue receives all mouse and keyboard messages for the windows created by the thread. The thread removes messages from its queue and directs the system to send them to the appropriate window procedure for processing.

Message → Foreground → Active

## Implementation
```cpp
// XP SP1

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
