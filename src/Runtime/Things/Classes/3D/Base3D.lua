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

    self.Dynamic = false

    self.Proxy.Property("Transform3D Transform", "boolean Dynamic")
    self.Proxy.Group("Physics", "Dynamic")
    self.Proxy.Group("Transform", "Transform")
end

---@return Environment
function Base3D:GetWorld()
    return self:GetParentCallback(function(ParentObject)
        return ParentObject:IsA("Environment")
    end)
end

function Base3D:SetTransform(NewTransform)
    self.Transform = NewTransform
end

function Base3D:Update(dt)
    ---@class DreamObject
    local Drawable = self.Drawable

    self.Position = self.Transform.Position

    Drawable:resetTransform()
    Drawable:setTransform(self.Transform.GetMatrix())
end

return Base3D