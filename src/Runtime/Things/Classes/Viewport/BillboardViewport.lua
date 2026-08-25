local Things = Runtime.Things
local Renderer = Runtime.Renderer

---@class BillboardViewport: SurfaceViewport
local BillboardViewport = Things.Extend("SurfaceViewport")

function BillboardViewport:ViewportDefineAPI()
    self.Proxy.Icon("BillboardViewport")
end

function BillboardViewport:UpdateDrawable(Parent)
    local ParentViewport = self:GetDisplayUI(true)
    if (not ParentViewport) then return end

    Renderer.Billboard.UpdateTransform(self, Parent.Position, ParentViewport)
end

return BillboardViewport