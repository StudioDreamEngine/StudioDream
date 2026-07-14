local Things = Runtime.Things

---@class BillboardViewport: SurfaceViewport
local BillboardViewport = Things.Extend("SurfaceViewport")

function BillboardViewport:ViewportDefineAPI()
end

function BillboardViewport:UpdateDrawable(Parent)
    local Position = Parent.Position
    local X,Y,Z = Position.X, Position.Y, Position.Z

    local ParentViewport = self:GetDisplayUI()
    if (not ParentViewport) then return end

    if ParentViewport:IsA("Environment") and ParentViewport.Camera then
        local DreamCamera = ParentViewport.Camera.Drawable

        self.Drawable:setTransform(self.Mesh:getSpriteTransform(X,Y,Z,0,1,1,DreamCamera))
    end
end

return BillboardViewport