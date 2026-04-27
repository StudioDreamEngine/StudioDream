local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
---@class Square
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Square"
    }
end

function Square:Draw()
    local Size = self.AbsoluteSize

    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y)
end

return Square