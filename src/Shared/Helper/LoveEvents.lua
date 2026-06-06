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

---@param Event Signal
for EventName, Event in pairs(LoveEvents) do
    love[string.lower(EventName)] = function(...) Event.Invoke(nil, ...) end
end

-- TODO: Perhaps also assign draw, load and update to events?

return LoveEvents