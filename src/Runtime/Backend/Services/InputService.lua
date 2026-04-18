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
        Ended = {}
    }
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

function InputService:InputEnded()
    local UUID = CreateUUID()
    local Signal = Signal:new("SignalDefaultWowz")
    self.EventsConnected.Ended[UUID] = Signal
    return Signal
end

function NotifyInput(IsBegan, Key, EventPass)
    local EventIn = IsBegan and EventPass.Began or EventPass.Ended

    for _, Signal in pairs(EventIn) do
        Signal:Invoke(Key)
    end
end

function InputService:GetJoystickInfo() -- Change this to input changed or something liek that
    local selfed = {}

    function selfed:GetJoystickAxis()
        return Joystick:getAxis()
    end

    return selfed
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

return InputService