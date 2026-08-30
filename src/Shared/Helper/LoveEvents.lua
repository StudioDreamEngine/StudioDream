local LoveEvents = {}

LoveEvents.KeyPressed = Signal:New("KeyPress")
LoveEvents.KeyReleased = Signal:New("KeyRelease")

LoveEvents.MousePressed = Signal:New("MousePress")
LoveEvents.MouseReleased = Signal:New("MouseRelease")
LoveEvents.MouseMoved = Signal:New("MouseMove")

LoveEvents.WheelMoved = Signal:New("WheelMoved")

LoveEvents.Resize = Signal:New("Resize")
LoveEvents.TextInput = Signal:New("TextInput")

LoveEvents.Focus = Signal:New("Focus")

LoveEvents.JoystickRemoved = Signal:New("JoystickConnected")
LoveEvents.JoystickAdded = Signal:New("JoystickDisconnected")

LoveEvents.JoystickReleased = Signal:New("JoystickReleased")
LoveEvents.JoystickPressed = Signal:New("JoystickPressed")

---@param Event Signal
for EventName, Event in pairs(LoveEvents) do
    love[string.lower(EventName)] = function(...) 
        -- TODO: Fix this later, doesnt matter for now
        --[[if EventName == "TextInput" and love.keyboard.isDown(".") then
            return
        end]]
        
        Event.Invoke(nil, ...) 
    end
end

-- TODO: Perhaps also assign draw, load and update to events?
-- i just realized we cant assign any of those (w/ this system atleast), 
-- load is called too early for this, draw doesnt need to be, update is what the signal system runs on

return LoveEvents