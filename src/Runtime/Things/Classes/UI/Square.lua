-- please stfu lsp
---@diagnostic disable: param-type-mismatch, need-check-nil

local Things = Runtime.Things
local Interface = Runtime.Renderer.Interface

-- using @module here gives the lua language server a base type to use!
---@class Square: BaseGui
local Square = Things.Extend("BaseGui")

function Square:new()
    Square.super.new(self)

    self.CornerRadius = Corners.new(0,0,0,0)

    self.Gradient = nil ---@class GradientSequence
    self.Corners = nil

    self.OutlineSize = 0
    self.OutlineColor = Color.new(0,0,0)
    self.OutlineTransparency = 0

    self.LimitCornerRadius = true

    --self.InterfaceShader = nil
    --self.ShaderObject = nil
end

function Square:DefineAPI()
    Square.super.DefineAPI(self)

    self.Proxy.Property("Corners CornerRadius", "number OutlineSize", "Color OutlineColor","number BackgroundTransparency", "Color BackgroundColor", "boolean Hovering","boolean LimitCornerRadius")
    self.Proxy.Property("GradientSequence Gradient", "boolean Dropshadow")
    self.Proxy.Group("Outline", "CornerRadius", "OutlineSize", "OutlineColor","LimitCornerRadius")
    self.Proxy.Group("Visual", "BackgroundTransparency", "BackgroundColor", "Gradient", "Dropshadow")
    self.Proxy.Icon("Square")
    
    self.Proxy.MakeCreatable()

    self.Proxy.Describe("Basic 2D Square")
end

--[[function Square:SetShader(Identifier)
    self.ShaderObject, self.InterfaceShader = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Shader")
    if (not self.ShaderObject) then return end
end]]

function Square:UpdateCorners()
    self.Corners = Interface.RectWithCorners(self.AbsoluteSize, self.CornerRadius*2, self.LimitCornerRadius)
end

function Square:SetCornerRadius(New)
    self.CornerRadius = New

    if type(self.CornerRadius) == "number" then
        self.CornerRadius = Corners.new(self.CornerRadius)
    end

    self:UpdateCorners()
end

function Square:SetAbsoluteSize(NewSize) -- this was kinda fun to do
    Square.super.SetAbsoluteSize(self, NewSize)
    self:UpdateCorners()
end

function Square:SetGradient(NewGrad)
    self.Gradient = NewGrad
    if self.Gradient then
        self.Gradient:ProcessUniforms()
    end
end

function Square:SetOutlineSize(number)
    self.OutlineSize = number
end

function Square:Draw()
    love.graphics.polygon("fill", self.Corners)
    
    if self.OutlineSize > 0 then
        love.graphics.setLineWidth(self.OutlineSize)
        self:SetColor("Outline")
        love.graphics.polygon("line", self.Corners)
    end
end

return Square