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
    self.Velocity = Vector3.zero

    self.Material = nil
end

function Drawable3D:DefineAPI()
    Drawable3D.super.DefineAPI(self)

    self.Proxy.Property("Vector3 Scale")--, "boolean Outline")
    self.Proxy.Property("Thing Material")
    self.Proxy.Property("Vector3 Velocity")

    self.Proxy.Group("Physics", "Dynamic", "Velocity")
    self.Proxy.Group("Transform", "Scale")
    self.Proxy.Group("Visuals", "Material")
end

function Drawable3D:SetOutline(Toggle)
    self.Outline = Toggle
end

---@param NewVelocity Vector3
function Drawable3D:SetVelocity(NewVelocity)
    self.Velocity = NewVelocity

    print(NewVelocity)
    self.PhysicsBody:setLinearVelocity(NewVelocity.ToBullet())
    self.PhysicsBody:activate()
end

function Drawable3D:GetPhysicsTransform()
    return self.PhysicsBody:getWorldTransform()
end

function Drawable3D:DefineMaterial(Material)
    self.Material = Material
    self.Drawable:setMaterial(Material.DreamMaterial)
end

function Drawable3D:SetTransform(NewTransform)
    Drawable3D.super.SetTransform(self, NewTransform)
    
    self.PhysicsBody:setWorldTransform(Runtime.Phys.ToBullet(NewTransform))
    self.PhysicsBody:activate()
end

function Drawable3D:SetScale(NewScale)
    self.Scale = NewScale

    self.PhysicsShape = Runtime.Phys.ShapeFromMesh(self.Drawable:getAllMeshes(), self.Scale)
    self:CreateBody()
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
    self.Resource = NewResource
    self.Drawable = Runtime.Backend3D.LoadObject(NewResource, self.UUID)

    self.Size = self.Scale * self.Drawable:getBoundingSphere().size

    self.PhysicsShape = Runtime.Phys.ShapeFromMesh(self.Drawable:getAllMeshes(), self.Scale)

    self:CreateBody()
end

function Drawable3D:Update(dt)
    Drawable3D.super.Update(self, dt)
    self.Drawable:scale(self.Scale.ToDream())
    self.Size = self.Scale * self.Drawable:getBoundingSphere().size

    if self.Dynamic then
        self.Velocity = Vector3.FromBullet(self.PhysicsBody:getLinearVelocity())
    end

    for _, Mesh in pairs(self.Drawable:getAllMeshes()) do
        Mesh[1].material.stencil = self.Outline
    end
end

return Drawable3D