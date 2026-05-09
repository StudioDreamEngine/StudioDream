---@class InputService
local InputService = {}

function InputService.Init()
    InputService.AxisPrevious = {}
    InputService.AxisCurrent = {}

    InputService.CurrentPressed = {}

    InputService.InputBegan = Signal:New("InputBeganSignal")
    InputService.InputEnded = Signal:New("InputEndSignal")

    InputService.MouseDown = Signal:New("MouseDownSignal")
    InputService.MouseUp = Signal:New("MouseUpSignal")
    InputService.MouseMoved = Signal:New("MouseMoveSignal")

    -- Pass the value itself as we assume the enum is used anyways
    LoveEvents.MousePressed:Connect(function(_,_,button) InputService.MouseDown.Invoke(button) end)
    LoveEvents.MouseReleased:Connect(function(_,_,button) InputService.MouseUp.Invoke(button) end)
    LoveEvents.MouseMoved:Connect(function(x,y,dx,dy) 
        local MouseObject = { Position = Vector2.new(x,y), Delta = Vector2.new(dx,dy) } ---@class InputMouseObject
        InputService.MouseMoved.Invoke(nil, MouseObject) 
    end)

    LoveEvents.KeyPressed:Connect(function(Key) 
        InputService.InputBegan.Invoke(Key)
        InputService.CurrentPressed[Key] = true
    end)
    LoveEvents.KeyReleased:Connect(function(Key) 
        InputService.InputEnded.Invoke(Key)
        InputService.CurrentPressed[Key] = false
    end)
end

function InputService.KeyDown(Key) -- Be enum based
    return InputService.CurrentPressed[Key] and true or false
end

function InputService.MouseButtonDown(MouseButton)
    return Runtime.Backend2D.GetMouseDown(MouseButton)
end

function InputService.InputChanged()
    local UUID = CreateUUID()
    local SignalCool = Signal:New("SignalDefaultWowz")
    InputService.EventsConnected.Changed[UUID] = SignalCool
    return SignalCool
end

function InputService.JoystickConnect(ContollerID)
    local InputServiceed = {}

    local joysticks = love.joystick.getJoysticks()
    local js = joysticks[ContollerID]

    function InputServiceed:HasController()
        if not js and not #joysticks>1 then
            return false
        else
            return true
        end
    end

    function InputServiceed:GetControllerName()
        js:getName()
    end

    function InputServiceed:GetJoyAxis(JoyId)
        if JoyId == 1 then
            return Vector2.new(js:getAxis(1),js:getAxis(2))
        elseif JoyId == 2 then
            return Vector2.new(js:getAxis(3),js:getAxis(4))
        end
    end

    return InputServiceed
end

function InputService.Update()

end

return InputService