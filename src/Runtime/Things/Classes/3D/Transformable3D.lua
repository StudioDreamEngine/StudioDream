-- Base object for ALL 3d objects that have a transform, but dont have a drawable
local Things = Runtime.Things

---@class Transformable3D: Thing
local Transformable3D = Things.Extend("Thing")

function Transformable3D:new()
    Transformable3D.super.new(self)

    self.TopLevel = false -- yes im stealing this from godot

    --self.GlobalTransform = Dream.mat4.getIdentity()
    
    self.Position = Vector3.zero
    self.Transform = Transform3D.FromPosition(0,0,0)
    self.LocalTransform = Transform3D.FromPosition(0,0,0)

    self.Scale = Vector3.one -- Not used by anything except Drawable3D, but needed in this class
end

function Transformable3D:DefineAPI()
    Transformable3D.super.DefineAPI(self)

    self.Proxy.Property("Transform3D LocalTransform")
    self.Proxy.Group("Transform","LocalTransform")
end

---@return Environment
function Transformable3D:GetWorld()
    return self:GetParentCallback(function(ParentObject)
        return ParentObject:IsA("Environment")
    end)
end

function Transformable3D:IsTopLevel()
    return self.TopLevel
end

function Transformable3D:UpdateMatrix()
    self.Matrix = self.Transform.GetMatrix():scale(self.Scale:ToDream()) * self.LocalTransform.GetMatrix()
end

function Transformable3D:SetLocalTransform(NewTransform)
    self.LocalTransform = NewTransform
    self:UpdateMatrix()
end

function Transformable3D:SetTransform(NewTransform)
    assert(NewTransform, "Attempted to set transform to nil")

    self.Transform = NewTransform
    self.Position = self.Transform.Position

    self:UpdateMatrix()
end

function Transformable3D:SetPosition(NewPosition)
    self.Position = NewPosition
    self.Transform = Transform3D.FromPosition(NewPosition) * self.Transform.Rotation

    self:UpdateMatrix()
end

function Transformable3D:SetScale(NewScale)
    self.Scale = NewScale
    self:UpdateMatrix()
end

function Transformable3D:Update(dt)
    self.Position = self.Transform.Position
end

return Transformable3D