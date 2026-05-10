local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.CornerRadius = 0

    self.Explorer = {
        Visible = true,
        Icon = "Square"
    }

    self.Proxy.Property("CornerRadius")
end

function Square:Draw()
    local Size = self.AbsoluteSize

    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)
end

return Square