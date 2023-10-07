# Asynchronous Procedure Calls
## Remove APCs for a thread
[Remove APC Entry List](https://www.unknowncheats.me/forum/anti-cheat-bypass/492358-remove-apc-entry-list.html)

## Disable APCs for a thread
- `KTHREAD.MiscFlags.ApcQueueable`
  
  [Make thread non-apc queueable](https://www.unknowncheats.me/forum/anti-cheat-bypass/492141-thread-apc-queueable.html)
- `KeEnterGuardedRegion()` and `KeLeaveGuardedRegion()`
  
  `KTHREAD.SpecialApcDisable`
- IRQL ≥ APC_LEVEL