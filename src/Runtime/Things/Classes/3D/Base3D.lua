-- Base object for ALL 3d objects, drawable or not
local Things = Runtime.Things

---@class Base3D: Thing
local Base3D = Things.Extend("Thing")

function Base3D:new()
    Base3D.super.new(self)

    self.Explorer = {
        Visible = false,
        Icon = "MeshPart"
    }

    self.Position     = Vector3.new(1,1,1)
    self.Transform    = Transform3D.FromPosition(0,0,0)

    self.Anchored    = true

    self.Proxy.Property("Transform", "Anchored")
end

function Base3D:Update(dt)
    ---@class DreamObject
    local Drawable = self.Drawable

    self.Position = self.Transform.Position

    Drawable:resetTransform()
    Drawable:setTransform(self.Transform.GetMatrix())
end

return Base3D