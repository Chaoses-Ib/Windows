# Scheduling
## [→Thread Priority](../../Threads/Scheduling/Priority.md)

## CPU usage
[c# calculate CPU usage for a specific application - Stack Overflow](https://stackoverflow.com/questions/1277556/c-sharp-calculate-cpu-usage-for-a-specific-application)
- `Process.TotalProcessorTime`

  ```csharp
  public async Task<double> GetCpuUsage(Process process) {
      var lastTime = DateTime.Now;
      var lastTotalProcessorTime = process.TotalProcessorTime;

      await Task.Delay(500);

      var curTime = DateTime.Now;
      var curTotalProcessorTime = process.TotalProcessorTime;

      return (curTotalProcessorTime.TotalMilliseconds - lastTotalProcessorTime.TotalMilliseconds) / curTime.Subtract(lastTime).TotalMilliseconds / Environment.ProcessorCount * 100.0;
  }
  ```

- `PerformanceCounter`

  ```csharp
  public async Task<float> GetCpuUsage(Process process)
  {
      string? processInstance = null;

      foreach (var instance in new PerformanceCounterCategory("Process").GetInstanceNames())
      {
          if (instance.StartsWith(process.ProcessName))
          {
              using var processId = new PerformanceCounter("Process", "ID Process", instance, true);
              if (process.Id == (int)processId.RawValue)
              {
                  processInstance = instance;
                  break;
              }
          }
      }

      if (processInstance == null)
      {
          return 0;
      }

      var cpu = new PerformanceCounter("Process", "% Processor Time", processInstance, true);

      cpu.NextValue();

      await Task.Delay(500);

      return cpu.NextValue() / Environment.ProcessorCount;
  }
  ```

[win11 任务管理器 CPU 利用率错误 - V2EX](https://www.v2ex.com/t/1022021)