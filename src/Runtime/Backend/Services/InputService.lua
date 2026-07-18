---@class InputService
local InputService = {}

function InputService.Init()
    InputService.KeyEvent = Signal:New("KeyEvent")
    InputService.MouseEvent = Signal:New("MouseEventSignal")
    InputService.MouseMoved = Signal:New("MouseMoveSignal")

    -- Pass the value itself as we assume the enum is used anyways
    LoveEvents.MousePressed:Connect(function(_,_,button) InputService.MouseEvent.Invoke(button, true)  end)
    LoveEvents.MouseReleased:Connect(function(_,_,button) InputService.MouseEvent.Invoke(button, false) end)

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
