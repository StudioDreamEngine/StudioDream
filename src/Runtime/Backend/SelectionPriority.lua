-- Manage the priority of selection signals on the viewport
-- You might wonder: Why Runtime? well... its because of the 3DControls!
---@class SelectionPriorityService
local SelectionPriorityService = {}

local Signals = {}

SelectionPriorityService.GuiClick = Signal:New("GuiClick")

function SelectionPriorityService.Init()
    local InputService = Runtime.Services.Service("InputService") ---@class InputService

    InputService.MouseEvent:Connect(SelectionPriorityService.Call, Enum.MouseButton.LeftClick)
end

function SelectionPriorityService.Call(IsDown)
    local EnvironmentViewport = Runtime.Things.Root.EnvironmentViewport

    if Runtime.InterfaceManager.Hovering then
        if (not IsDown) then 
            printVerbose("Click Invoked")
            SelectionPriorityService.GuiClick:Invoke() 
        end

        return
    end

    if (not EnvironmentViewport) or (not Utils.IntersectPoint2D(Rect.new(Vector2.zero, EnvironmentViewport.AbsoluteSize), EnvironmentViewport.MousePosition)) then
        print("No EnvironmentViewport is specified currently, skipping SelectionPriorityService call...")
        return
    end

    --[[if IsDown then
        return
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
        printVerbose("SelectionPriority Function invoked")
        HighestPriority.Function(IsDown)
    end
end

function SelectionPriorityService.BindSignal(Function, Priority, CheckFunction)
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

function SelectionPriorityService.UnbindSignal(UUID)
    Signals[UUID] = nil
end

return SelectionPriorityService