-- Manage the priority of selection signals
local SelectionPriority = {}

local Signals = {}

function SelectionPriority.Init()
    local InputService = Runtime.Services.Service("InputService") ---@class InputService

    InputService.MouseEvent:Connect(SelectionPriority.Call, Enum.MouseButton.LeftClick)
end

function SelectionPriority.Call(IsDown)
    --[[if (not IsDown) then
        
    end]]
    
    local HighestPriority = {
        Priority = 0
    }

    for _, SignalData in pairs(Signals) do
        if SignalData.CheckFunction() and SignalData.Priority > HighestPriority.Priority then
            HighestPriority = SignalData
        end
    end

    HighestPriority.Function(IsDown)
end

function SelectionPriority.BindSignal(Function, Priority, CheckFunction)
    local UUID = CreateUUID()

    Signals[UUID] = {
        Priority = Priority,
        CheckFunction = CheckFunction or function()
            return true
        end,
        Function = Function
    }
    return UUID
end

function SelectionPriority.UnbindSignal(UUID)
    Signals[UUID] = nil
end

return SelectionPriority