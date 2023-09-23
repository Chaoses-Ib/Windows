# Synchronization
Windows is a tightly coupled, symmetric multiprocessing (SMP) operating system.[^winter]

## High-IRQL synchronization
Because the scheduler synchronizes access to its data structures at DPC/dispatch level IRQL, the kernel and executive cannot rely on synchronization mechanisms that would result in a page fault or reschedule operation to synchronize access to data structures when the IRQL is DPC/dispatch level or higher (levels known as an *elevated* or *high* IRQL).

### Interlocked operations

### Spinlocks
Spinlocks, like the data structures they protect, reside in nonpaged memory mapped into the system address space.

All kernel-mode spinlocks in Windows have an associated IRQL that is always DPC/dispatch level or higher. Thus, when a thread is trying to acquire a spinlock, all other activity at the spinlock's IRQL or lower ceases on that processor.

API:
- `KeAcquireSpinLock`, `KeReleaseSpinLock`
- `KeAcquireInterruptSpinLock`, `KeReleaseInterruptSpinLock`
- `KeSynchronizeExecution`

### Queued spinlocks
A queued spinlock works like this: When a processor wants to acquire a queued spinlock that is currently held, it places its identifier in a queue associated with the spinlock. When the processor that's holding the spinlock releases it, it hands the lock over to the next processor identified in the queue. In the meantime, a processor waiting for a busy spinlock checks the status not of the spinlock itself but of a per-processor flag that the processor ahead of it in the queue sets to indicate that the waiting processor's turn has arrived.

Global queued spinlocks:
- `KPCR.LockArray`, `KSPIN_LOCK_QUEUE_NUMBER`
- `KeAcquireQueuedSpinLock`

In-stack queued spinlocks:
- `KeAcquireInStackQueued`, `KeReleaseInStackQueuedSpinLock`

Reader/writer spin locks (executive spinlocks):
- `ExAcquireSpinLockExclusive`, `ExAcquireSpinLockShared`
- ExReleaseXxx
- `ExTryAcquireSpinLockSharedAtDpcLevel`
- `ExTryConvertSharedSpinLockToExclusive`

### Executive interlocked operations
Arithmetic:
- `ExInterlockedAddUlong`, `ExInterlockedAddLargeInteger`
  
  These calls are now deprecated and are silently inlined in favor of the intrinsic functions.

Singly linked lists:
- `ExInterlockedPopEntryList`, `ExInterlockedPushEntryList`

Doubly linked lists:
- `ExInterlockedInsertHeadList`, `ExInterlockedRemoveHeadList`

## Low-IRQL synchronization
- Kernel dispatcher objects (mutexes, semaphores, events, and timers)
- Fast mutexes and guarded mutexes
- Pushlocks
- Executive resources
- Run-once initialization (InitOnce)

User-mode-specific locking primitives:
- System calls that refer to kernel dispatcher objects (mutants, semaphores, events, and timers)
- Condition variables (CondVars)
- Slim Reader-Writer Locks (SRW Locks)
- Address-based waiting
- Run-once initialization (InitOnce)
- Critical sections

Sync mechanisms | Exposed for Use by Device Drivers | Disables Normal Kernel-Mode APCs | Disables Special Kernel-Mode APCs | Supports Recursive Acquisition | Supports Shared and Exclusive Acquisition
--- | --- | --- | --- | --- | ---
Kernel dispatcher<br />mutexes | ✔️ | ✔️ | ❌ | ✔️ | ❌
Kernel dispatcher<br />semaphores, events, timers | ✔️ | ❌ | ❌ | ❌ | ❌
Fast mutexes | ✔️ | ✔️ | ✔️ | ❌ | ❌
Guarded mutexes | ✔️ | ✔️ | ✔️ | ❌ | ❌
Pushlocks | ✔️ | ❌ | ❌ | ❌ | ❌
Executive resources | ✔️ | ❌ | ❌ | ✔️ | ✔️
Rundown protections | ✔️ | ❌ | ❌ | ✔️ | ❌

### Kernel dispatcher objects
A thread in a Windows application can synchronize with a variety of objects, including a Windows process, thread, event, semaphore, mutex, waitable timer, I/O completion port, ALPC port, registry key, or file object. In fact, almost all objects exposed by the kernel can be waited on. Some of these are proper dispatcher objects, whereas others are larger objects that have a dispatcher object within them (such as ports, keys, or files).

Waiting:
- KeWaitForXxx
- NtWaitForXxx
  - `WaitForSingleObject`
  - `WaitForMultipleObjects`

Asynchronous waiting:
- I/O completion port
  - `CreateThreadPoolWait`, `SetThreadPoolWait`
- DPC Wait Event

### Object-less waiting
The Windows kernel provides two mechanisms for synchronization that are not tied to dispatcher objects:
- Thread alerts

  First, the thread wishing to synchronize enters an *alertable sleep* by using `SleepEx` (ultimately resulting in `NtDelayExecutionThread`). A kernel thread could also choose to use `KeDelayExecutionThread`. Secondly, the other side uses the `NtAlertThread` (or `KeAlertThread`) API to alert the thread, which causes the sleep to abort, returning the status code `STATUS_ALERTED`. A thread can choose not to enter an alertable sleep state, but instead, at a later time of its choosing, call the `NtTestAlert` (or `KeTestAlertThread`) API. Finally, a thread could also avoid entering an alertable wait state by suspending itself instead (`NtSuspendThread` or `KeSuspendThread`). In this case, the other side can use `NtAlertResumeThread` to both alert the thread and then resume it.

- Thread alert by ID (Windows 8)
  - `NtAlertThreadByThreadId`
  - `NtWaitForAlertByThreadId`

  Can only be used to synchronize with threads within the current process.

Which of thread alerts and events are faster? 

### Keyed events
A **keyed event** allows a thread to specify a “key” for which it waits, where the thread wakes when another thread of the same process signals the event with the same key. A keyed event is Windows' equivalent of the futex in the Linux operating system.

If there was contention, `EnterCriticalSection` would dynamically allocate an event object, and the thread wanting to acquire the critical section would wait for the thread that owns the critical section to signal it in `LeaveCriticalSection`. Clearly, this introduces a problem during low-memory conditions. And low memory wasn't the only scenario that could cause this to fail—a less likely scenario was handle exhaustion.

The main feature of keyed events, however, was that a single event could be reused among different threads, as long as each one provided a different *key* to distinguish itself. By providing the virtual address of the critical section itself as the key, this effectively allows multiple critical sections (and thus, waiters) to use the same keyed event handle, which can be preallocated at process startup time.

However, keyed events were more than just a fallback object for low-memory conditions. When multiple waiters are waiting on the same key and need to be woken up, the key is signaled multiple times, which requires the object to keep a list of all the waiters so that it can perform a “wake” operation on each of them. owever, a thread can signal a keyed event without any threads on the waiter list. In this scenario, the signaling thread instead waits on the event itself. 

Keyed events, however, did not replace standard event objects in the critical section implementation. The initial reason, during the Windows XP timeframe, was that keyed events did not offer scalable performance in heavy-usage scenarios.

Windows Vista improved keyed-event performance by using a hash table instead of a linked list to hold the waiter threads. This optimization is what ultimately allowed Windows to include the three new lightweight user-mode synchronization primitives that all depended on the keyed event.

With the introduction of the new *alerting by Thread ID* capabilities in Windows 8, however, this all changed again, removing the usage of keyed events across the system (save for one situation in *init once* synchronization). And, as more time had passed, the critical section structure eventually dropped its usage of a regular event object and moved toward using this new capability as well (with an application compatibility shim that can revert to using the original event object if needed).

### Fast mutexes and guard mutexes
- `ExAcquireFastMutex`, `ExAcquireFastMutexUnsafe`
- `ExTryToAcquireFastMutex`

In Windows 8 and later, guarded mutexes are identical to fast mutexes but are acquired with `KeAcquireGuardedMutex` and `KeAcquireGuardedMutexUnsafe`. Like fast mutexes, a `KeTryToAcquireGuardedMutex` method also exists. 

Prior to Windows 8, these functions did not disable APCs by raising the IRQL to APC level, but by entering a guarded region instead, which set special counters in the thread's object structure to disable APC delivery until the region was exited.

### Executive resources
Executive resources are a synchronization mechanism that supports shared and exclusive access.

### Pushlocks
Pushlocks are another optimized synchronization mechanism built on event objects; like fast and guarded mutexes, they wait for an event only when there's contention on the lock. They offer advantages over them, however, in that they can also be acquired in shared or exclusive mode, just like an executive resource. Unlike the latter, however, they provide an additional advantage due to their size: a resource object is 104 bytes, but a pushlock is pointer sized. Because of this, pushlocks do not require allocation nor initialization and are guaranteed to work in low-memory conditions. Many components inside of the kernel moved away from executive resources to pushlocks, and modern third-party drivers all use pushlocks as well.

### Address-based waits
Address-based waits are based on alert-by-ID.

API:
- `WaitOnAddress`
- `WakeByAddressSingle`, `WakeByAddressAll`

### Critical sections

### User-mode resources

### Condition variables
Condition variables provide a Windows native implementation for synchronizing a set of threads that are waiting on a specific result to a conditional test.

### Slim Reader/Writer (SRW) locks

### Run once initialization


[^winter]: Windows Internals