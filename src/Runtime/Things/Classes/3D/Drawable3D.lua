local Things = Runtime.Things

---@class Drawable3D: Base3D
local Drawable3D = Things.Extend("Base3D")

function Drawable3D:new()
    Drawable3D.super.new(self)

    self.Outline = false
    self.Drawable = nil ---@class DreamObject
    self.Resource = nil

    self.Matrix = Dream.mat4.getIdentity()

    self.Collidable = true

    self.PhysicsBody = nil
    self.PhysicsShape = nil

    self.Mass = 1
    self.Velocity = Vector3.zero
    self.RotationalVelocity = Vector3.zero

    self.Material = Dream:newMaterial()
    printVerbose("Create reflection")
    self._Reflection = Dream:newReflection(love.graphics.newCubeImage("Assets/sky.png"))
end

function Drawable3D:DefineAPI()
    Drawable3D.super.DefineAPI(self)

    self.Proxy.Property("Vector3 Scale")--, "boolean Outline")
    self.Proxy.Property("Thing Material")
    self.Proxy.Property("Vector3 Velocity", "Vector3 RotationalVelocity", "boolean Collidable")

    self.Proxy.Group("Physics", "Dynamic", "Velocity", "RotationalVelocity", "Collidable")
    self.Proxy.Group("Transform", "Scale")
    self.Proxy.Group("Visuals", "Material")
end

function Drawable3D:SetOutline(Toggle)
    self.Outline = Toggle
end

function Drawable3D:SetCollidable(New)
    self.Collidable = New

    if (not self.Collidable) then -- We dont need to care about adding the body back, HandlePhysicsHierachy does that for us once Collidable is true
        self:RemoveBody()
    end
end

function Drawable3D:OnRemove()
    self:RemoveBody() -- the fact we dont havent made this a thing until 0.9
    Drawable3D.super.OnRemove(self)
end

function Drawable3D:SetMaterial(NewMaterial)
    printVerbose(NewMaterial)
    self.Material = NewMaterial
end

---@param NewVelocity Vector3
function Drawable3D:SetVelocity(NewVelocity)
    if (not self.PhysicsBody) then return end

    printVerbose(NewVelocity)
    self.PhysicsBody:setLinearVelocity(NewVelocity:ToBullet())
    self.PhysicsBody:activate()
end

function Drawable3D:SetRotationalVelocity(NewVelocity)
    if (not self.PhysicsBody) then return end

    self.PhysicsBody:setAngularVelocity(NewVelocity:ToBullet())
    self.PhysicsBody:activate()
end

function Drawable3D:GetPhysicsTransform()
    return self.PhysicsBody:getWorldTransform()
end

function Drawable3D:UpdatePhysicsTransform()
    self.PhysicsBody:setWorldTransform(Runtime.Phys:ToBullet(self.Transform))
    self.PhysicsBody:activate()
end

function Drawable3D:SetTransform(NewTransform)
    Drawable3D.super.SetTransform(self, NewTransform)
    
    if self.PhysicsBody then
        self:UpdatePhysicsTransform()
    end
end

function Drawable3D:UpdateBounds()
    self.Drawable:updateBoundingSphere(self.Scale:Magnitude())
end

function Drawable3D:SetScale(NewScale)
    self.Scale = NewScale
    self.Size = self.Scale * self.Drawable:getBoundingBox()

    self.PhysicsShape = Runtime.Phys.ShapeFromMesh(self.Drawable, self.Scale)

    self:UpdateBounds()
    self:CreateBody()
end

function Drawable3D:SetDynamic(NewDynamic)
    self.Dynamic = NewDynamic

    self:CreateBody()
    self:UpdatePhysicsTransform()
end

function Drawable3D:RemoveBody()
    local World = self:GetWorld()

    if World then
        World:RemoveBody(self)
    end
end

function Drawable3D:CanAddBody()
    return self.Collidable
end

function Drawable3D:CreateBody()
    self:RemoveBody()
end

function Drawable3D:AddTask()
    Dream:addMesh(self.Drawable, self.Matrix, self.Material)
end

function Drawable3D:CheckAABB(Min, Max)
    local DrawableMin = self.Position - self.Size/2
    local DrawableMax = self.Position + self.Size/2

    return (DrawableMin.X < Min.X) and (DrawableMax.X > Max.X) 
        and (DrawableMin.Y < Min.Y) and (DrawableMax.Y > Max.Y) 
        and (DrawableMin.Z < Min.Z) and (DrawableMax.Z > Max.Z)
end

-- Hacky mesh resource system because dream loads an object directly from a file's contents
function Drawable3D:SetResource(NewResource)
    self.Drawable, self.Resource = Runtime.Backend3D.LoadMesh(NewResource, self.UUID)
    if (not self.Drawable) then return end

    self.Size = self.Scale * self.Drawable:getBoundingBox()
    self.PhysicsShape = Runtime.Phys.ShapeFromMesh(self.Drawable, self.Scale)

    self:CreateBody()
end

function Drawable3D:Update(dt)
    Drawable3D.super.Update(self, dt)
    if (not self.Drawable) then return end

    self.Matrix = self.Transform.GetMatrix():scale(self.Scale:ToDream())
    self.Mass = 1
    
    self.Drawable.reflection = self.Material and (self.Material.Reflective and self._Reflection or false) or false
end

return Drawable3D