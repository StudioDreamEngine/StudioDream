-- My idea for this is someth like the list layouts, using the constraint system
---@class ScrollContainer: Square
local ScrollContainer = Things.Extend("Square")

function ScrollContainer:new()
    ScrollContainer.super.new(self)
end

function ScrollContainer:Update(dt)
    
end

return ScrollContainer