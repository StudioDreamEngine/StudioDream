local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.TrueRadiousOfCorners = 0
    self.CornerRadius = 0

    self.OutlineSize = 0
    self.OutlineColor = Color.new(0,0,0)
    self.OutlineTransparency = 0
    self.HasDropShadow = false -- vro
    self.LimitCornerRadious = true
end

function Square:DefineAPI()
    Square.super.DefineAPI(self)

    self.Proxy.Property("number CornerRadius", "number OutlineSize", "Color OutlineColor","number BackgroundTransparency", "Color BackgroundColor", "boolean Hovering","boolean LimitCornerRadious")
    self.Proxy.Group("Outline", "CornerRadius", "OutlineSize", "OutlineColor","LimitCornerRadious")
    self.Proxy.Group("Visual", "BackgroundTransparency", "BackgroundColor")
    self.Proxy.MakeCreatable()
end

function Square:CalculateRadius()
    if self.LimitCornerRadious then
        local Size = Vector2.new(self.AbsoluteSize.X/2,self.AbsoluteSize.Y/2).Y
        if self.CornerRadius > Size then
            self.TrueRadiousOfCorners = Size
        else
            self.TrueRadiousOfCorners = self.CornerRadius
        end
    else 
        self.TrueRadiousOfCorners = self.CornerRadius
    end
end

function Square:SetOutlineSize(number)
    self.OutlineSize = number
end

function Square:Draw()
    local Size = self.AbsoluteSize 
    local r,g,b,a = love.graphics.getColor()
    
    self:CalculateRadius()

    love.graphics.setColor(r,g,b,a)
    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.TrueRadiousOfCorners, self.TrueRadiousOfCorners)
    
    if self.OutlineSize > 0 then
        love.graphics.setLineWidth(self.OutlineSize)
        self:SetColor("Outline")
        love.graphics.rectangle("line", 0,0, Size.X, Size.Y, self.TrueRadiousOfCorners, self.TrueRadiousOfCorners)
    end
end

return Square