local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local SquarePrimative = Things.Extend("BaseGui")

function SquarePrimative:New()
    self.super:New()

    self.Explorer = {
        Visible = true,
        Icon = "shape"
    }
end

function SquarePrimative:Draw()
    local Size = self.AbsoluteSize

    love.graphics.rectangle("fill", 0, 0, Size.X, Size.Y)
end

return SquarePrimative