-- Manage the priority of selection signals on the viewport
local SelectionPriority = {}

local Signals = {}

function SelectionPriority.Init()
    local InputService = Runtime.Services.Service("InputService") ---@class InputService

    InputService.MouseEvent:Connect(SelectionPriority.Call, Enum.MouseButton.LeftClick)
end

function SelectionPriority.Call(IsDown)
    local EnvironmentViewport = Runtime.Things.Root.EnvironmentViewport

    if IsDown and (not Utils.IntersectPoint2D(Rect.new(Vector2.zero, EnvironmentViewport.AbsoluteSize), EnvironmentViewport.MousePosition)) then
        return
    end

    --[[if (not IsDown) then
        
    end]]
    
    local HighestPriority = {
        Priority = 0
    }

    for _, SignalData in pairs(Signals) do
        if SignalData.CheckFunction(IsDown) and SignalData.Priority > HighestPriority.Priority then
            HighestPriority = SignalData
        end
    end

    if HighestPriority.Function then
        HighestPriority.Function(IsDown)
    end
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