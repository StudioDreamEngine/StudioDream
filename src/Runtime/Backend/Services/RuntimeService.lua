---@class RuntimeService
local RuntimeService = {}
local Running = false

function RuntimeService.IsRunning() return Running end

function RuntimeService.Start()
    printVerbose("RuntimeService.Start was called, note this is CANNOT be reversed unless the entire engine is restarted.")

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