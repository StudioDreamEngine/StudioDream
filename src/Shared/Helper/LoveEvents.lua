local LoveEvents = {}

LoveEvents.KeyPressed = Signal:New("KeyPressed")
LoveEvents.KeyReleased = Signal:New("KeyReleased")

LoveEvents.MousePressed = Signal:New("MousePressed")
LoveEvents.MouseReleased = Signal:New("MouseReleased")

LoveEvents.Resize = Signal:New("Resize")

---@param Event Signal
for EventName, Event in pairs(LoveEvents) do
    love[string.lower(EventName)] = function(...) Event.Invoke(nil, ...) end
end

-- TODO: Perhaps also assign draw, load and update to events?

return LoveEvents