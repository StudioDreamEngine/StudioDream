local InputService = {}

function InputService.Init()
    print("hi i inited!")
    InputService.CurrentPressed = {}
    InputService.EventsConnected = {
        Began = {},
        Ended = {},

        Changed = {},
    }
    InputService.AxisPrevious = {}
    InputService.AxisCurrent = {}

    InputService.InputBegan = Signal:New("InputBeganSignal")

    InputService.MouseDown = Signal:New("MouseDownSignal")
    InputService.MouseUp = Signal:New("MouseUpSignal")

    --InputService.MouseClicked = InputService.MouseUp -- For ease of use
end

function InputService.SetViewportDefaultOnService(View)
    Viewport = View
end

function InputService.IsKeyDown(Key) -- Be enum based
    return InputService.CurrentPressed[Key] and true or false
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

function InputService.InputEnded()
    local UUID = CreateUUID()
    local Signal = Signal:New("SignalDefaultWowz")
    InputService.EventsConnected.Ended[UUID] = Signal
    return Signal
end

function NotifyInput(IsBegan, Key, EventPass,JoystickID)
    local EventIn = IsBegan and EventPass.Began or EventPass.Ended

    for _, Signal in pairs(EventIn) do
        Signal:Invoke(Key,JoystickID)
    end
end

function InputService.keypressed(Key)
    Key = Enum.InputCode.NameFromValue(Key)
    InputService.CurrentPressed[Key] = true
    InputService.InputBegan:Invoke(Key)
end

function InputService.keyreleased(Key)
    Key = Enum.InputCode.NameFromValue(Key)
    InputService.CurrentPressed[Key] = nil
    NotifyInput(false,Key,InputService.EventsConnected)
end

--[[function InputService.gamepadpressed(joystick, Key)
    Key = "gp_" .. Key
    Key = ToEnum(Key)
    InputService.CurrentPressed[Key] = true
    NotifyInput(true, Key, InputService.EventsConnected,Joystick:getID())
end

function InputService.gamepadreleased(joystick, Key)
    Key = "gp_" .. Key
    Key = ToEnum(Key)
    InputService.CurrentPressed[Key] = nil
    NotifyInput(false, Key, InputService.EventsConnected,Joystick:getID())
end]]

function InputService.mousepressed(x,y,button,isTouch)
    local Button = Enum.InputCode.NameFromValue(button)
end

function InputService.mousereleased(x,y,button,isTouch)
    local Button = Enum.InputCode.NameFromValue(button)
end

function InputService.Update()
end

return InputService