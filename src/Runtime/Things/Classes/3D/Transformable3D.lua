-- Base object for ALL 3d objects, drawable or not
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
    self.Transform = NewTransform
    self.Position = self.Transform.Position
end

function Transformable3D:SetPosition(NewPosition)
    self.Position = NewPosition
    self.Transform = Transform3D.FromMatrix(self.Transform.Rotation) * Transform3D.FromPosition(NewPosition)
end

function Transformable3D:Update(dt)
    self.Position = self.Transform.Position
end

return Transformable3D