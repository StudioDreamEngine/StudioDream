local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.CornerRadius = 0

    self.OutlineSize = 0
    self.OutlineColor = Color.new(0,0,0)
    self.OutlineTransparency = 0
    self.HasDropShadow = false -- vro
end

function Square:DefineAPI()
    Square.super.DefineAPI(self)

    self.Proxy.Property("number CornerRadius", "number OutlineSize", "Color OutlineColor","number BackgroundTransparency", "Color BackgroundColor", "boolean Hovering")
    self.Proxy.Group("Outline", "CornerRadius", "OutlineSize", "OutlineColor")
    self.Proxy.Group("Visual", "BackgroundTransparency", "BackgroundColor")
    self.Proxy.MakeCreatable()
end

function Square:SetOutlineSize(number)
    self.OutlineSize = number
end

function Square:Draw()
    local Size = self.AbsoluteSize 
    local r,g,b,a = love.graphics.getColor()

    if self.HasDropShadow then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0,3, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)
    end
    
    love.graphics.setColor(r,g,b,a)
    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)
    
    if self.OutlineSize > 0 then
        love.graphics.setLineWidth(self.OutlineSize)
        self:SetColor("Outline")
        love.graphics.rectangle("line", 0,0, Size.X, Size.Y, self.CornerRadius, self.CornerRadius)
    end
end

return Square