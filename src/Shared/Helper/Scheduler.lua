--[[
    Bloctans 2025-2026

    Implements preemptive multitasking, because lua is dumb

    Please make sure to yield tasks, because thats what allows the scheduler to actually perform the preemptive multitasking
]]

---@class Scheduler
local Scheduler = {}

local ActiveTasks = {} -- List of current tasks that exist, note even if a task is paused it is still in this list.
local PausedTasks = {} -- List of tasks that are waiting to run
local CancelingTasks = {} -- List of tasks that will be canceled on next yield

-- Start a new task
function Scheduler.NewTask(Function, ...)
    return Scheduler.DelayTask(0, Function, ...)
end

-- Start a new scheduler task on an infinite loop
function Scheduler.NewTaskLoop(Function, ...)
    return Scheduler.NewTask(function(...)
        while true do
            Function(...)
            Scheduler.Yield()
        end
    end, ...)
end

-- Debug function
function Scheduler.GetTasks()
    local i = 0
    for _, _ in pairs(ActiveTasks) do i = i + 1 end
    return i
end

function Scheduler.PauseTask(Task, Paused)
    local CurrentTask = coroutine.running()

    assert(CurrentTask ~= Task, "Cannot currently run PauseTask in the current task!")

    PausedTasks[Task] = {

    }
end

-- Cancel task
function Scheduler.CancelTask(Thread)
    if (coroutine.status(Thread) == "running") then
        error("Coroutine needs to be yielded or dead in order to be canceled.")
        return -- Needed? idk
    end

    CancelingTasks[Thread] = true
end

-- Start a new task (after a delay)
function Scheduler.DelayTask(Time, Function, ...)
    local Coroutine = coroutine.create(Function)

    ActiveTasks[Coroutine] = true
    PausedTasks[Coroutine] = {
        Time = GlobalTick + Time,
        Args = table.pack(...)
    }

    return Coroutine
end

function Scheduler.IsRunning(Task)
    return ActiveTasks[Task] and true or false
end

-- Yield task until it can be resumed
-- If no yield time is passed, it will be resumed the next possible frame
function Scheduler.Yield(YieldTime)
    assert((not YieldTime) or (type(YieldTime) == "number"), "Invalid Yieldtime! Expected number, got "..(YieldTime or "nil"))

    local Task = coroutine.running()

    if (not Task) then
        error("Attempted to yield main task. (if you intended to yield the main task, use 'love.timer.sleep()' instead)")
    end

    PausedTasks[Task] = {
        Time = GlobalTick + (YieldTime or 0),
    }

    coroutine.yield() 
end

function Scheduler.Update()
    -- Resume any tasks that should no longer be yielded
    for Coroutine, Data in pairs(PausedTasks) do
        if GlobalTick > Data.Time then
            PausedTasks[Coroutine] = nil

            -- Handle errors for coroutines, as their errors are not handled by the love error handler.

            local Success, Msg

            if Data.Args then
                Success, Msg = coroutine.resume(Coroutine, unpack(Data.Args))
            else
                Success, Msg = coroutine.resume(Coroutine)
            end

            if not Success then 
                error("Error occurred while running task\n"..debug.traceback(Coroutine, Msg)) 
            end
        end
    end

    -- Cleanup any tasks that are marked dead
    for Coroutine, Data in pairs(ActiveTasks) do
        if coroutine.status(Coroutine) == "dead" then
            Scheduler.CancelTask(Coroutine)
        end
    end

    -- Force remove any canceled task
    for Task, _ in pairs(CancelingTasks) do
        -- We cannot close the coroutine on lua 5.1, so we pray the garbage collector does the work for us.
        ActiveTasks[Task] = nil
        PausedTasks[Task] = nil
    end

    -- Clear all canceling tasks, since im lazy
    CancelingTasks = {}
end

return Scheduler