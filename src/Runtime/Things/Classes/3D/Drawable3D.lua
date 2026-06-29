local Things = Runtime.Things

---@class Drawable3D: Base3D
local Drawable3D = Things.Extend("Base3D")

function Drawable3D:new()
    Drawable3D.super.new(self)

    self.Outline = false
    self.Drawable = nil ---@class DreamObject
    self.Resource = nil

    self.PhysicsBody = nil
    self.PhysicsShape = nil

    self.Velocity = Vector3.zero

    self.Material = Dream:newMaterial()
    self._Reflection = Dream:newReflection(love.graphics.newCubeImage("Assets/sky.png"))
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

function Drawable3D:SetMaterial(NewMaterial)
    printVerbose(NewMaterial)
    self.Material = NewMaterial

    self:AttemptMaterialSet()
end

function Drawable3D:AttemptMaterialSet()
    if self.Drawable and self.Material and self.Material:IsA("Material") then
        self.Drawable:setMaterial(self.Material)
    else
        printVerbose("Material invalid or no drawable set")
    end
end

---@param NewVelocity Vector3
function Drawable3D:SetVelocity(NewVelocity)
    printVerbose(NewVelocity)
    self.PhysicsBody:setLinearVelocity(NewVelocity.ToBullet())
    self.PhysicsBody:activate()
end

function Drawable3D:GetPhysicsTransform()
    return self.PhysicsBody:getWorldTransform()
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
    self.Drawable, self.Resource = Runtime.Backend3D.LoadObject(NewResource, self.UUID)
    self:AttemptMaterialSet()

    self.Size = self.Scale * self.Drawable:getBoundingSphere().size

    self.PhysicsShape = Runtime.Phys.ShapeFromMesh(self.Drawable:getAllMeshes(), self.Scale)

    self:CreateBody()
end

function Drawable3D:Update(dt)
    Drawable3D.super.Update(self, dt)
    self.Drawable:scale(self.Scale.ToDream())
    self.Size = self.Scale * self.Drawable:getBoundingSphere().size
    
    self.Drawable.reflection = self.Material and (self.Material.Reflective and self._Reflection or false) or false
end

return Drawable3D