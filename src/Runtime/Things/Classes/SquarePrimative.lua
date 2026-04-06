local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local SquarePrimative = Things.Extend("BaseGui")

function SquarePrimative:new()
    SquarePrimative.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "shape_square"
    }
    self.Position = Vector2.new(0,0)
end

function SquarePrimative:Draw()
    local Size = self.AbsoluteSize

    love.graphics.rectangle("fill", self.Position.X, self.Position.Y, Size.X, Size.Y)
end

return SquarePrimative