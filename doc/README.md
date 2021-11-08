# WKWebview 内存

代码
https://github.com/WebKit/WebKit/blob/99dc96c5a55e6e36852370897d58c123d1be4c89/Source/WTF/wtf/MemoryPressureHandler.cpp

计算当前进程内存使用量
```
size_t memoryFootprint()
{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (result != KERN_SUCCESS)
        return 0;
    return static_cast<size_t>(vmInfo.phys_footprint);
}
```
计算内存上限
```
static size_t thresholdForMemoryKillOfInactiveProcess(unsigned tabCount)
{
#if CPU(X86_64) || CPU(ARM64)
    size_t baseThreshold = 3 * GB + tabCount * GB;
#else
    size_t baseThreshold = tabCount > 1 ? 3 * GB : 2 * GB;
#endif
    return std::min(baseThreshold, static_cast<size_t>(ramSize() * 0.9));
}

```
iOS最终调用jetsamLimit函数实现
```
static size_t jetsamLimit()
{
    memorystatus_memlimit_properties_t properties;
    pid_t pid = getpid();
    if (memorystatus_control(MEMORYSTATUS_CMD_GET_MEMLIMIT_PROPERTIES, pid, 0, &properties, sizeof(properties)))
        return 840 * bmalloc::MB;
    if (properties.memlimit_active < 0)
        return std::numeric_limits<size_t>::max();
    return static_cast<size_t>(properties.memlimit_active) * bmalloc::MB;
}
```
定时检测内存，当前进程内存使用量大于上限
```
void MemoryPressureHandler::measurementTimerFired()
{
    size_t footprint = memoryFootprint();
#if PLATFORM(COCOA)
    RELEASE_LOG(MemoryPressure, "Current memory footprint: %zu MB", footprint / MB);
#endif
    auto killThreshold = thresholdForMemoryKill();
    if (killThreshold && footprint >= *killThreshold) {
        shrinkOrDie(*killThreshold);
        return;
    }

    setMemoryUsagePolicyBasedOnFootprint(footprint);

    switch (m_memoryUsagePolicy) {
    case MemoryUsagePolicy::Unrestricted:
        break;
    case MemoryUsagePolicy::Conservative:
        releaseMemory(Critical::No, Synchronous::No);
        break;
    case MemoryUsagePolicy::Strict:
        releaseMemory(Critical::Yes, Synchronous::No);
        break;
    }

    if (processState() == WebsamProcessState::Active && footprint > thresholdForMemoryKillOfInactiveProcess(m_pageCount))
        doesExceedInactiveLimitWhileActive();
    else
        doesNotExceedInactiveLimitWhileActive();
}
```
向WebProcessProxy发送消息
```
 memoryPressureHandler.setShouldUsePeriodicMemoryMonitor(true);
 memoryPressureHandler.setMemoryKillCallback([this] () {
     WebCore::logMemoryStatisticsAtTimeOfDeath();
    if (MemoryPressureHandler::singleton().processState() == WebsamProcessState::Active)
        parentProcessConnection()->send(Messages::WebProcessProxy::DidExceedActiveMemoryLimit(), 0);
     else
        parentProcessConnection()->send(Messages::WebProcessProxy::DidExceedInactiveMemoryLimit(), 0);
    });
    memoryPressureHandler.setDidExceedInactiveLimitWhileActiveCallback([this] () {
         parentProcessConnection()->send(Messages::WebProcessProxy::DidExceedInactiveMemoryLimitWhileActive(), 0);
    });
```
WebProcessProxy收到内存上限消息，requestTermination结束进程
```
void WebProcessProxy::didExceedActiveMemoryLimit()
{
    WEBPROCESSPROXY_RELEASE_LOG_ERROR(PerformanceLogging, "didExceedActiveMemoryLimit: Terminating WebProcess because it has exceeded the active memory limit");
    logDiagnosticMessageForResourceLimitTermination(DiagnosticLoggingKeys::exceededActiveMemoryLimitKey());
    requestTermination(ProcessTerminationReason::ExceededMemoryLimit);
}

void WebProcessProxy::didExceedInactiveMemoryLimit()
{
    WEBPROCESSPROXY_RELEASE_LOG_ERROR(PerformanceLogging, "didExceedInactiveMemoryLimit: Terminating WebProcess because it has exceeded the inactive memory limit");
    logDiagnosticMessageForResourceLimitTermination(DiagnosticLoggingKeys::exceededInactiveMemoryLimitKey());
    requestTermination(ProcessTerminationReason::ExceededMemoryLimit);
}
```


测试

Iphone6s           白屏日志 无
Iphone6          白屏日志EXC_RESOURCE -> com.apple.WebKit.WebContent[365] exceeded mem limit: ActiveSoft 840 MB (non-fatal)
Iphone Xs Max   白屏日志 EXC_RESOURCE -> com.apple.WebKit.WebContent[8137] exceeded mem limit: ActiveSoft 1536 MB (non-fatal)


疑问   测试程序三台机器都返回840MB
```
static size_t jetsamLimit()
{
    memorystatus_memlimit_properties_t properties;
    pid_t pid = getpid();
    if (memorystatus_control(MEMORYSTATUS_CMD_GET_MEMLIMIT_PROPERTIES, pid, 0, &properties, sizeof(properties)))
        return 840 * bmalloc::MB; //测试程序三台机器都返回840MB
    if (properties.memlimit_active < 0)
        return std::numeric_limits<size_t>::max();
    return static_cast<size_t>(properties.memlimit_active) * bmalloc::MB;
}
```
