-- please stfu lsp
---@diagnostic disable: param-type-mismatch, need-check-nil

local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.TrueRadiusOfCorners = 0
    self.CornerRadius = 0

    self.Gradient = nil ---@class GradientSequence

    self.OutlineSize = 0
    self.OutlineColor = Color.new(0,0,0)
    self.OutlineTransparency = 0

    self.LimitCornerRadius = true

    --self.InterfaceShader = nil
    --self.ShaderObject = nil
end

function Square:DefineAPI()
    Square.super.DefineAPI(self)

    self.Proxy.Property("number CornerRadius", "number OutlineSize", "Color OutlineColor","number BackgroundTransparency", "Color BackgroundColor", "boolean Hovering","boolean LimitCornerRadius")
    self.Proxy.Property("GradientSequence Gradient", "boolean Dropshadow")
    self.Proxy.Group("Outline", "CornerRadius", "OutlineSize", "OutlineColor","LimitCornerRadius")
    self.Proxy.Group("Visual", "BackgroundTransparency", "BackgroundColor", "Gradient", "Dropshadow")
    self.Proxy.MakeCreatable()
end

--[[function Square:SetShader(Identifier)
    self.ShaderObject, self.InterfaceShader = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Shader")
    if (not self.ShaderObject) then return end
end]]

function Square:CalculateRadius() -- this was kinda fun to do
    if self.LimitCornerRadius then
        local Size = (self.AbsoluteSize.X < self.AbsoluteSize.Y) and self.AbsoluteSize.X/2 or self.AbsoluteSize.Y/2
        self.TrueRadiusOfCorners = (self.CornerRadius > Size) and Size or self.CornerRadius
    else 
        self.TrueRadiusOfCorners = self.CornerRadius
    end
end

function Square:SetGradient(NewGrad)
    self.Gradient = NewGrad
    self.Gradient:ProcessUniforms()
end

function Square:SetOutlineSize(number)
    self.OutlineSize = number
end

-- oh boy, MORE ABSTRACTION!!! LOVELY!!!$
function Square:DrawExtended()
    Runtime.Backend2D.ShaderCall(function(Shader)
        if self.Gradient then
            Shader:sendColor("gradient.colors", self.Gradient.GetColors())
            Shader:send("gradient.time", self.Gradient.GetTimes())
            Shader:send("gradient_length", self.Gradient.GetKeyLength())
        else
            Shader:send("gradient_length", 0)
        end

        Shader:send("effect_bitmask", (self.Dropshadow and 1 or 0))

        self:Draw()
    end, "Interface")
end

function Square:Draw()
    local Size = self.AbsoluteSize 
    local r,g,b,a = love.graphics.getColor()
    
    self:CalculateRadius()

    love.graphics.setColor(r,g,b,a)
    love.graphics.rectangle("fill", 0,0, Size.X, Size.Y, self.TrueRadiusOfCorners, self.TrueRadiusOfCorners)
    
    if self.OutlineSize > 0 then
        love.graphics.setLineWidth(self.OutlineSize)
        self:SetColor("Outline")
        love.graphics.rectangle("line", 0,0, Size.X, Size.Y, self.TrueRadiusOfCorners, self.TrueRadiusOfCorners)
    end
end

return Square