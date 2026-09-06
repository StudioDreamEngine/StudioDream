local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Primitive: Drawable3D
local Primitive = Things.Extend("Drawable3D")

function Primitive:new()
    Primitive.super.new(self)

    self.Shape = Enum.Shape.Cube
    
    self._LastShape = self.Shape
end

function Primitive:OnReady()
    self:CheckShape()
end

function Primitive:DefineAPI()
    Primitive.super.DefineAPI(self)

    self.Proxy.Icon("Scene")

    self.Proxy.Property("Enum.Shape Shape")
    self.Proxy.Group("Visuals", "Shape")

    self.Proxy.MakeCreatable()
end

function Primitive:EnableParticle()
    Dream:addParticleSystems(self.Drawable)
end

function Primitive:CheckShape()
    if self._LastShape ~= self.Shape or not self.Drawable then
        local PrimativeIdentifier = Runtime.Resources.GetIdentifierFromID("Internal/DefaultMeshes/"..self.Shape..".obj") or "Internal/DefaultMeshes/cube.obj"
        self:SetResource(PrimativeIdentifier)
        
        printVerbose("Made new Drawable")
    end

    self._LastShape = self.Shape
end

function Primitive:Update(dt)
    self:CheckShape()

    Primitive.super.Update(self, dt)
end

return Primitive