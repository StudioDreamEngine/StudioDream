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

-- Ignore the code blockout!! cus idk how to do services rn
function RuntimeService.Init()
    RuntimeService.OnStep = Signal:New("GameStep")
    RuntimeService.OnRunning = Signal:New("OnRunning")
end

function RuntimeService.Update(dt)
    RuntimeService.OnStep:Invoke(dt)
end

return RuntimeService