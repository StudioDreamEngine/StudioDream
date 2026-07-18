-- Base object for ALL 3d objects that have a transform, but dont have a drawable
local Things = Runtime.Things

---@class Transformable3D: Thing
local Transformable3D = Things.Extend("Thing")

function Transformable3D:new()
    Transformable3D.super.new(self)

    self.Position = Vector3.zero
    self.Transform = Transform3D.FromPosition(0,0,0)
    self.Scale = Vector3.one -- Not used by anything except Drawable3D, but needed in this class
end

function Transformable3D:SetTransform(NewTransform)
    assert(NewTransform, "Attempted to set transform to nil")

    self.Transform = NewTransform
    self.Position = self.Transform.Position
end

function Transformable3D:SetPosition(NewPosition)
    self.Position = NewPosition
    self.Transform = Transform3D.FromPosition(NewPosition) * self.Transform.Rotation
end

function Transformable3D:Update(dt)
    self.Position = self.Transform.Position
end

return Transformable3D