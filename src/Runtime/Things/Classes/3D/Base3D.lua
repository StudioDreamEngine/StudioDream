-- Base object for ALL 3d objects, drawable or not
local Things = Runtime.Things

---@class Base3D: Thing
local Base3D = Things.Extend("Thing")

function Base3D:new()
    Base3D.super.new(self)

    self.Explorer = {
        Visible = false,
        UseNewIcon = true,
        Icon = "MeshPart"
    }

    self.Size        = Vector3.new(1, 1, 1)
    self.Position    = Vector3.new(0, 0, 0)
    self.Orientation = Vector3.new(0, 0, 0)

    self.Anchored    = true
end

function Base3D:Update(dt)
    local Drawable = self.Drawable

    Drawable:resetTransform()
    Drawable:scaleWorld(self.Size.ToDream())
    Drawable:translate(self.Position.ToDream())
    Drawable:rotateX(self.Orientation.X)
    Drawable:rotateY(self.Orientation.Y)
    Drawable:rotateZ(self.Orientation.Z)
end

return Base3D