local Things = Runtime.Things

---@class SurfaceViewport: Viewport2D
local SurfaceViewport = Things.Extend("Viewport2D")

function SurfaceViewport:new()
    SurfaceViewport.super.new(self)

    self.Drawable = Dream:newObject()
    self.Mesh = Dream:newSprite(self.ViewportCanvas)
    self.Mesh.material.Alpha = true
    self.Mesh.material.Simple = true

    self.DisplaySide = Enum.Side.Front

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

function SurfaceViewport:OnRemove()
    SurfaceViewport.super.OnRemove(self)
    Runtime.Backend3D.UnregisterObject(self.UUID)
end

function SurfaceViewport:ViewportDefineAPI()
    self.Proxy.Property("Enum.Side DisplaySide")
    self.Proxy.Group("General", "DisplaySide")
end

function SurfaceViewport:DefineAPI()
    SurfaceViewport.super.DefineAPI(self)

    self:ViewportDefineAPI()
    
    --[[self.Proxy.Property("Thing RenderContainer")
    self.Proxy.Group("General", "RenderContainer")]]
    self.Proxy.Icon("SurfaceViewport")
end

function SurfaceViewport:CreateNew()
    SurfaceViewport.super.CreateNew(self)
    self.Mesh.material:SetAlbedoTexture(self.ViewportCanvas)
end

function SurfaceViewport:UpdateDrawable(Parent)
    local TransformPos = Parent.Transform.Position.ToDream()
    local DisplaySide = self.DisplaySide.ToDream()

    local LookatMatrix = Dream:lookAt(TransformPos, DisplaySide)

    self.Drawable:setTransform(LookatMatrix)
    self.Drawable:translate(0,0,0.02)
    self.Drawable:scale(Parent.Size.X, Parent.Size.Y, Parent.Size.Z)
    self.Drawable:translate(0,0,1)
end

function SurfaceViewport:Update(dt)
    SurfaceViewport.super.Update(self, dt)

    local Parent = self.Parent
    if not Parent:IsA("Drawable3D") then return end

    Runtime.Renderer.ViewportManager.RenderViewport2D(self)
    self:UpdateDrawable(Parent)
end

return SurfaceViewport