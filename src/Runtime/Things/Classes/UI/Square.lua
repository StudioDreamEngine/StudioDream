local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.CornerRadius = 0

    self.OutlineSize = 0
    self.OutlineColor = Color.new(0,0,0)
end

function Square:DefineAPI()
    Square.super.DefineAPI(self)

    self.Proxy.Property("number CornerRadius", "number OutlineSize", "Color OutlineColor")
end

function Square:SetOutlineSize(number)
    self.OutlineSize = number
end

function Square:Draw()
    local Size = self.AbsoluteSize

    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)

    if self.OutlineSize > 0 then
        love.graphics.setLineWidth(self.OutlineSize)
        Runtime.Backend2D.SetColor(self.OutlineColor)
        love.graphics.rectangle("line", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)
    end
end

return Square