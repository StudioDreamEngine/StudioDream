local InputService = {}
local CurrentPs

local EnumReversed = {}

function ReverseEnum()
    for i,v in pairs(Enum.InputCode) do
        EnumReversed[v] = i
    end
end

function InputService:Init()
    print("hi i inited!")
    self.CurrentPressed = {}
    CurrentPs = self.CurrentPressed
    self.EventsConnected = {
        Began = {},
        Ended = {},

        Changed = {},
    }
    self.AxisPrevious = {}
    self.AxisCurrent = {}
    ReverseEnum()
end

function InputService:IsKeyDown(Key) -- Be enum based
    return self.CurrentPressed == Key and true or false
end

function InputService:InputBegan()
    local UUID = CreateUUID()
    local Signal = Signal:new("SignalDefaultWowz")
    self.EventsConnected.Began[UUID] = Signal
    return Signal
end

function InputService:InputChanged()
    local UUID = CreateUUID()
    local Signal = Signal:new("SignalDefaultWowz")
    self.EventsConnected.Changed[UUID] = Signal
    return Signal
end

function InputService:JoystickConnect(ContollerID)
    local selfed = {}

    local joysticks = love.joystick.getJoysticks()
    local js = joysticks[ContollerID]

    function selfed:HasController()
        if not js and not (#joysticks>1) then
            return false
        else
            return true
        end
    end

    function selfed:GetControllerName()
        js:getName()
    end

    function selfed:GetJoyAxis(JoyId)
        if JoyId == 1 then
            return Vector2.new(js:getAxis(1),js:getAxis(2))
        elseif JoyId == 2 then
            return Vector2.new(js:getAxis(3),js:getAxis(4))
        end
    end

    return selfed
end

function InputService:InputEnded()
    local UUID = CreateUUID()
    local Signal = Signal:new("SignalDefaultWowz")
    self.EventsConnected.Ended[UUID] = Signal
    return Signal
end

function NotifyInput(IsBegan, Key, EventPass,JoystickID)
    local EventIn = IsBegan and EventPass.Began or EventPass.Ended

    for _, Signal in pairs(EventIn) do
        Signal:Invoke(Key,JoystickID)
    end
end

function ToEnum(key)
    return EnumReversed[key] or "None"
end

function InputService:keypressed(Key)
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = true
    NotifyInput(true,Key,self.EventsConnected)
    print(Key)
    print(self.CurrentPressed)
end

function InputService:keyreleased(Key)
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = nil
    NotifyInput(false,Key,self.EventsConnected)
   -- print(Key)
end

function InputService:gamepadpressed(joystick, Key)
    Key = "gp_" .. Key
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = true
    NotifyInput(true, Key, self.EventsConnected,Joystick:getID())
    print(Key)
end

function InputService:gamepadreleased(joystick, Key)
    Key = "gp_" .. Key
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = nil
    NotifyInput(false, Key, self.EventsConnected,Joystick:getID())
    print(Key)
end

function InputService:Update()
    --local ControllerOne = InputService:JoystickConnect(1)
    --print(ControllerOne:GetJoyAxis(1))
end

return InputService