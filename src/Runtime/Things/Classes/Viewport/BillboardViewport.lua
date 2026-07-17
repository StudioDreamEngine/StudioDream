local Things = Runtime.Things

---@class BillboardViewport: SurfaceViewport
local BillboardViewport = Things.Extend("SurfaceViewport")

function BillboardViewport:ViewportDefineAPI()
    self.Proxy.Icon("BillboardViewport")
end

function BillboardViewport:UpdateDrawable(Parent)
    local Position = Parent.Position

    local ParentViewport = self:GetDisplayUI()
    if (not ParentViewport) then return end

    if ParentViewport:IsA("Environment") and ParentViewport.Camera then
        local Camera = ParentViewport.Camera ---@class Camera
        local Rotation = Camera.Transform.Rotation ---@class Transform3D

        self.Drawable:setTransform((Transform3D.FromPosition(Position) * Rotation).GetMatrix())
    end
end

return BillboardViewport