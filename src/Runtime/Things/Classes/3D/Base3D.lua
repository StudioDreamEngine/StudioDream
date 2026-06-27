-- Base object for ALL 3d objects, drawable or not
local Things = Runtime.Things

---@class Base3D: Transformable3D
local Base3D = Things.Extend("Transformable3D")

function Base3D:new()
    Base3D.super.new(self)

    self.Dynamic = false
end

function Base3D:DefineAPI()
    Base3D.super.DefineAPI(self)

    self.Proxy.Property("Transform3D Transform", "boolean Dynamic")
    self.Proxy.Group("Transform", "Transform")
end

---@return Environment
function Base3D:GetWorld()
    return self:GetParentCallback(function(ParentObject)
        return ParentObject:IsA("Environment")
    end)
end

function Base3D:Update(dt)
    Base3D.super.Update(self, dt)

    ---@class DreamObject
    local Drawable = self.Drawable

    Drawable:resetTransform()
    Drawable:setTransform(self.Transform.GetMatrix())
end

return Base3D