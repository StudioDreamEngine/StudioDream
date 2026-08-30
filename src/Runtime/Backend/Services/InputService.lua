---@class InputService
local InputService = {}

InputService.JoysticksConnected = {}

function InputService.GetJoystickByPrimitive(Primitive)
    for ID,Joysitck in pairs(InputService.JoysticksConnected) do
        if Joysitck.Primitive == Primitive then
            return Joystick
        end
    end
end

function InputService.GetJoystickByID(ID)
    return InputService.JoysticksConnected[ID]
end

function InputService.GetJoysticks()
    return InputService.JoysticksConnected
end

function InputService.GetJoystickCount()
    return #InputService.JoysticksConnected
end

local function CreateJoystickObject(LOVEJoyObj)
    if not LOVEJoyObj then return end
    
    local JoyObj = {}
    JoyObj.Name = LOVEJoyObj:getName()
    JoyObj.ID = LOVEJoyObj:getID()
    JoyObj.Primitive = LOVEJoyObj
    JoyObj.GUID = LOVEJoyObj:getGUID()

    JoyObj.ButtonPressed = Signal:New("JoystickButtonPressed")
    JoyObj.ButtonReleased = Signal:New("JoystickButtonReleased")

    JoyObj.Type = "Joystick"

    function JoyObj:IsGamepad()
        return LOVEJoyObj:isGamepad()
    end

    function JoyObj:IsButtonDown(Button)
        return LOVEJoyObj:isDown(Button)
    end

    function JoyObj:GetGamepadAxis(LeftOrRight)
        if string.find(LeftOrRight,"trigger") then
            return LOVEJoyObj:getGamepadAxis(LeftOrRight)
        else
            return Vector2.new(LOVEJoyObj:getGamepadAxis(LeftOrRight.."x"),LOVEJoyObj:getGamepadAxis(LeftOrRight.."y"))
        end
    end

    function JoyObj:GetAxis(CheckAxis)
        return LOVEJoyObj:getAxis(CheckAxis)
    end

    function JoyObj:IsVibrationSuported()
        return LOVEJoyObj:isVibrationSupported()
    end

    function JoyObj:GetVibration()
        if JoyObj:IsVibrationSuported() then
            local Returns1,Returns2 = LOVEJoyObj:getVibration()
            return {Returns1,Returns2}
        else
            if (not FLAGS.Independent) then
                assert("This type of controller doesnt suport vibration!")
            end
        end
    end

    function JoyObj:SetVibration(Left,Right)
        if JoyObj:IsVibrationSuported() then
            LOVEJoyObj:setVibration(Left,Right)
        else
            if (not FLAGS.Independent) then
                assert("This type of controller doesnt suport vibration!")
            end
        end
    end

    function JoyObj:Destroy()
        InputService.JoysticksConnected[JoyObj.ID] = nil
        LOVEJoyObj:release()
    end

    return JoyObj
end

function InputService.Init()
    InputService.KeyEvent = Signal:New("KeyEvent")
    InputService.MouseEvent = Signal:New("MouseEventSignal")
    InputService.MouseMoved = Signal:New("MouseMoveSignal")

    InputService.JoystickAdded = Signal:New("Input-JoystickConnect")
    InputService.JoystickRemoved = Signal:New("Input-JoystickRemove")

    -- Pass the value itself as we assume the enum is used anyways
    LoveEvents.MousePressed:Connect(function(_,_,button) InputService.MouseEvent.Invoke(button, true)  end)
    LoveEvents.MouseReleased:Connect(function(_,_,button) InputService.MouseEvent.Invoke(button, false) end)

    LoveEvents.JoystickAdded:Connect(function(Primitive) 
        local NewJoyObject = CreateJoystickObject(Primitive)
        InputService.JoysticksConnected[NewJoyObject.ID] = NewJoyObject
        InputService.JoystickAdded.Invoke(NewJoyObject)
    end)

    LoveEvents.JoystickRemoved:Connect(function(Primitive)
        local JoyObject = InputService.GetJoystickByPrimitive(Primitive)
        JoyObject:Destroy()
        InputService.JoystickRemoved.Invoke(NewJoyObject)
        InputService.JoysticksConnected[JoyObject.ID] = nil
    end)

    LoveEvents.JoystickPressed:Connect(function(Primitive,Button)
        local JoyObject = InputService.GetJoystickByPrimitive(Primitive)
        JoyObject.ButtonPressed.Invoke(Button)
    end)

    LoveEvents.JoystickReleased:Connect(function(Primitive,Button)
        local JoyObject = InputService.GetJoystickByPrimitive(Primitive)
        JoyObject.ButtonReleased.Invoke(Button)
    end)

    LoveEvents.MouseMoved:Connect(function(x,y,dx,dy) 
        local MouseObject = { Position = Vector2.new(x,y), Delta = Vector2.new(dx,dy) } ---@class InputMouseObject
        InputService.MouseMoved.Invoke(nil, MouseObject) 
    end)

    LoveEvents.KeyPressed:Connect(function(key) InputService.KeyEvent.Invoke(key, true)  end)
    LoveEvents.KeyReleased:Connect(function(key) InputService.KeyEvent.Invoke(key, false)  end)
end

InputService.KeyDown = Runtime.Backend2D.KeyDown
InputService.MouseButtonDown = Runtime.Backend2D.GetMouseDown

function InputService.KeyDownNumber(Key)
    return InputService.KeyDown(Key) and 1 or 0
end

function InputService.Update(dt)
    
end

return InputService
