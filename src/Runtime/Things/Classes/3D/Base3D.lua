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

    self.Proxy.SetHiperType("3D")

    self.Proxy.Property("Transform3D Transform", "boolean Dynamic")
    self.Proxy.Group("Transform", "Transform")
end

function Base3D:Update(dt)
    Base3D.super.Update(self, dt)

    ---@class DreamObject
    local Drawable = self.Drawable

    -- Base3D can either have no drawable or have a drawable depending on what object is extending the class
    if Drawable then
        Drawable:resetTransform()
        Drawable:setTransform(self.Transform.GetMatrix())
    end
end

return Base3D