local Things = Runtime.Things

---@class SurfaceViewport: Viewport2D
local SurfaceViewport = Things.Extend("Viewport2D")

function SurfaceViewport:new()
    SurfaceViewport.super.new(self)

    self.Drawable = Dream:newObject()
    self.Mesh = Dream:newSprite(self.ViewportCanvas)

    self.Drawable.meshes["Mesh"] = self.Mesh
end

function SurfaceViewport:SetParent(NewParent)
    local CouldParent, Reason = SurfaceViewport.super.SetParent(self, NewParent)

    if self.Parent and self.Parent:IsA("Drawable3D") then
        Runtime.Backend3D.RegisterObject(self.Drawable, self.UUID)
    else
        Runtime.Backend3D.UnregisterObject(self.UUID)
    end

    return CouldParent, Reason
end

function SurfaceViewport:SetAbsoluteSize(New)
    SurfaceViewport.super.SetAbsoluteSize(self, New)

    self.Mesh.material:SetAlbedoTexture(self.ViewportCanvas)
end

function SurfaceViewport:Update(dt)
    SurfaceViewport.super.Update(self, dt)

    local Parent = self.Parent
    if not Parent:IsA("Drawable3D") then return end

    Runtime.Renderer.ViewportManager.RenderViewport2D(self)

    self.Drawable:setTransform(Parent.Transform.GetMatrix())
    self.Drawable:translate(0,0,0.02)
    self.Drawable:scale(Parent.Size.X, Parent.Size.Y, Parent.Size.Z)
    self.Drawable:translate(0,0,1)
end

return SurfaceViewport