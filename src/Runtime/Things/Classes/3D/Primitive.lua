local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Primitive: Drawable3D
local Primitive = Things.Extend("Drawable3D")

function Primitive:new()
    Primitive.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Scene"
    }
    self.Shape = Enum.Shape.Brick
    
    self._LastShape = self.Shape
    self:CheckShape()

    self.Proxy.Property("Shape")
end

function Primitive:CheckShape()
    if self._LastShape ~= self.Shape or not self.Drawable then
        self:LoadObject(self.Shape)
        printVerbose("Made new Drawable")
    end

    self._LastShape = self.Shape
end

function Primitive:OnRemove()
    Primitive.super.OnRemove(self)
    Runtime.Backend3D.RemoveObject(self)
end

function Primitive:Update(dt)
    self:CheckShape()

    Primitive.super.Update(self, dt)
end

return Primitive