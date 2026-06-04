local Things = Runtime.Things

---@class Drawable3D: Base3D
local Drawable3D = Things.Extend("Base3D")

local StencilMaterial = Dream:newMaterial()
StencilMaterial.stencil = true

function Drawable3D:new()
    Drawable3D.super.new(self)

    self.Outline = false
    self.Drawable = nil ---@class DreamObject
    self.Resource = nil

    self.PhysicsBody = nil
    self.PhysicsShape = nil

    self.Scale = Vector3.new(1, 1, 1)
end

function Drawable3D:DefineAPI()
    Drawable3D.super.DefineAPI(self)

    self.Proxy.Property("Vector3 Scale", "boolean Outline", "FilePath MeshPath")
    self.Proxy.Group("Transform", "Scale")
    self.Proxy.Group("Visuals", "MeshPath")
end

function Drawable3D:OnRemove()
    Drawable3D.super.OnRemove(self)
end

function Drawable3D:SetOutline(Toggle)
    self.Outline = Toggle
end

function Drawable3D:GetPhysicsTransform()
    return self.PhysicsBody:getWorldTransform()
end

function Drawable3D:SetTransform(NewTransform)
    Drawable3D.super.SetTransform(self, NewTransform)
    self.PhysicsBody:setWorldTransform(Runtime.Phys.ToBullet(NewTransform))
    self.PhysicsBody:activate()
end

function Drawable3D:SetDynamic(NewDynamic)
    self.Dynamic = NewDynamic

    self:CreateBody()
end

function Drawable3D:CreateBody()
    local World = self:GetWorld()

    if World then
        World:RemoveBody(self)
    end

    self.PhysicsBody = Runtime.Phys.CreateBody(self.PhysicsShape, Runtime.Phys.ToBullet(self.Transform), self.Dynamic)
end

-- Hacky mesh resource system because dream loads an object directly from a file's contents
function Drawable3D:SetResource(NewResource)
    self.Drawable = Runtime.Backend3D.LoadObject(NewResource, self.UUID)

    self.Size = self.Scale * self.Drawable:getBoundingSphere().size

    self.PhysicsShape = Runtime.Phys.CreateShape(self.Size*2)

    self:CreateBody()
end

function Drawable3D:Update(dt)
    Drawable3D.super.Update(self, dt)
    self.Drawable:scale(self.Scale.ToDream())
    self.Size = self.Scale * self.Drawable:getBoundingSphere().size

    for _, Mesh in pairs(self.Drawable:getAllMeshes()) do
        Mesh[1].material.stencil = self.Outline
    end
end

return Drawable3D