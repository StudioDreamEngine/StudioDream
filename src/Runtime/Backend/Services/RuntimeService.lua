---@class RuntimeService
local RuntimeService = {}
local Running = false

function RuntimeService.IsRunning() return Running end

-- Starts any scripts within the project, and also sends an event that can be used by other stuff in the runtime
-- This is called manually by the client
function RuntimeService.StartActivity()
    printVerbose("RuntimeService.StartActivity was called, note this is CANNOT be reversed unless the entire engine is restarted.")

    Running = true
    Runtime.ScriptUtil.StartScripts()

    RuntimeService.OnRunning:Invoke()
end

-- Returns the current time since the game has started, calculated based of DeltaTime
function RuntimeService.GetGlobalTime()
    return GlobalTick
end

-- Returns the current unix time
function RuntimeService.GetUnixTime()
    return os.time()
end

-- Returns the current cpu time, as provided by os.clock
function RuntimeService.GetCpuTime()
    return os.clock()
end

-- Ignore the code blockout!! cus idk how to do services rn
function RuntimeService.Init()
    RuntimeService.OnStep = Signal:New("GameStep")
    RuntimeService.OnRunning = Signal:New("OnRunning")
end

function RuntimeService.Update(dt)
    RuntimeService.OnStep:Invoke(dt)
end

return RuntimeService