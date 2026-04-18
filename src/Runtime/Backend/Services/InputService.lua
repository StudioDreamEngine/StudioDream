local InputService = {}

function InputService:Init()
    self.CurrentPressed = nil

    self.EventsConnected = {
        Began = {},
        Ended = {}
    }
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

local function NotifyInput(IsBegan, Key)
    local EventIn = IsBegan and self.EventsConnected.Began or self.EventsConnected.Ended

    for _, Signal in pairs(EventIn) do
        Signal:Invoke(Key)
    end
end

function InputService:GetJoystickInfo()
    local selfed = {}

    function selfed:GetJoystickAxis()
        return Joystick:getAxis()
    end

    return selfed
end

function love.keypressed(Key)
    self.CurrentPressed = Key
    NofifyInput(true,Key)
end

function love.keyreleased(Key)
   self.CurrentPressed = nil
   NofifyInput(false,Key)
end

return InputService