local InputService = {}

local EnumReversed = {}
local Viewport

function ReverseEnum()
    for i,v in pairs(Enum.InputCode) do
        EnumReversed[v] = i
    end
end

function InputService:Init()
    print("hi i inited!")
    self.CurrentPressed = {}
    self.EventsConnected = {
        Began = {},
        Ended = {},

        Changed = {},
    }
    self.AxisPrevious = {}
    self.AxisCurrent = {}

    self.InputBegan = Signal:New("InputBeganSignal")

    ReverseEnum()
end

function InputService:SetViewportDefaultOnService(View)
    Viewport = View
end

function InputService:IsKeyDown(Key) -- Be enum based
    return self.CurrentPressed[Key] and true or false
end

function InputService:InputChanged()
    local UUID = CreateUUID()
    local SignalCool = Signal:New("SignalDefaultWowz")
    self.EventsConnected.Changed[UUID] = SignalCool
    return SignalCool
end

function InputService:JoystickConnect(ContollerID)
    local selfed = {}

    local joysticks = love.joystick.getJoysticks()
    local js = joysticks[ContollerID]

    function selfed:HasController()
        if not js and not #joysticks>1 then
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
    local Signal = Signal:New("SignalDefaultWowz")
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
    self.InputBegan:Invoke(Key)
end

function InputService:keyreleased(Key)
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = nil
    NotifyInput(false,Key,self.EventsConnected)
end

function InputService:gamepadpressed(joystick, Key)
    Key = "gp_" .. Key
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = true
    NotifyInput(true, Key, self.EventsConnected,Joystick:getID())
end

function InputService:gamepadreleased(joystick, Key)
    Key = "gp_" .. Key
    Key = ToEnum(Key)
    self.CurrentPressed[Key] = nil
    NotifyInput(false, Key, self.EventsConnected,Joystick:getID())
end

function InputService:mousepressed(x,y,button,isTouch)
    local PressedWhat = isTouch and "mtouch" or (button == 1 and "mlclick" or "mrclick")
    PressedWhat = ToEnum(PressedWhat)
    self.InputBegan:Invoke(PressedWhat)
    self.CurrentPressed[PressedWhat] = true
    NotifyInput(true, PressedWhat, self.EventsConnected,PressedWhat)
end

function InputService:mousereleased(x,y,button,isTouch)
    local PressedWhat = isTouch and "mtouch" or (button == 1 and "mlclick" or "mrclick")
    PressedWhat = ToEnum(PressedWhat)
    self.CurrentPressed[PressedWhat] = nil
    NotifyInput(false, PressedWhat, self.EventsConnected,PressedWhat)
    print(PressedWhat)
end

function InputService:Update()
    if Viewport then
        local mouseX = Viewport.MousePosition.X
        local mouseY = Viewport.MousePosition.Y

        local origin = Viewport.Camera.position
      
       --[[ local hit = Services.RaycastService:Raycast(scene, origin, direction)

        if hit then
            local MouseHit = hit.position
            local MouseTarget = hit.mesh

            print(MouseHit, MouseTarget)
        end]]
    end
end

return InputService