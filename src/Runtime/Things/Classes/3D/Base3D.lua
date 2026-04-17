local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
---@class Base3D
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
    Drawable:translate(self.Position.X, self.Position.Y, self.Position.Z)
    Drawable:rotateX(self.Orientation.X)
    Drawable:rotateY(self.Orientation.Y)
    Drawable:rotateZ(self.Orientation.Z)
    Drawable:scaleWorld(self.Size.X, self.Size.Y, self.Size.Z)
end

return Base3D