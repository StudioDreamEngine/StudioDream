local Things = Runtime.Things
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService
local Renderer = Runtime.Renderer

---@class SurfaceViewport: Viewport2D
local SurfaceViewport = Things.Extend("Viewport2D")

function SurfaceViewport:new()
    SurfaceViewport.super.new(self)

    self.Mesh, self.Drawable, self.CanvasIdentifier = Renderer.Billboard.CreateBillboard(self.ViewportCanvas)

    self.Drawable.ClassReference = self

    self.DisplaySide = Enum.Side.Front
    self.DisableDepth = false
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
    self.Proxy.Property("Enum.Side DisplaySide", "boolean DisableDepth")
    self.Proxy.Group("Viewport", "DisplaySide", "DisableDepth")
end

-- Fired only during API dump and after inital creation
-- we define everything for this specific object as im too lazy to enable unregistering
function SurfaceViewport:DefineAPI()
    self.Proxy = Things.ObjectProxy.new()

    self:ViewportDefineAPI()

    self.Proxy.MakeCreatable()
    self.Proxy.SetCategory("Viewport")
    self.Proxy.Icon("SurfaceViewport")

    -- Thing
    self.Proxy.Property("Thing Parent", "string Name")
    self.Proxy.Group("General", "Parent", "Name")

    self.Proxy.Group("Attributes")

    -- BaseGui
    self.Proxy.Property("Pivot2D Size", "boolean Visible")
    self.Proxy.Property("Color BackgroundColor", "number ColorMultiplier")

    self.Proxy.Group("Transform", "Size")
    self.Proxy.Group("Layout", "Visible")
    self.Proxy.Group("Color", "ColorMultiplier")

    -- Viewport
    self.Proxy.Property("Thing RenderContainer", "Enum.FilterType FilterType")
    self.Proxy.Group("Viewport", "RenderContainer", "FilterType")
end

function SurfaceViewport:CreateNew()
    SurfaceViewport.super.CreateNew(self)

    if self.Drawable then
        Runtime.Resources.ChangeBuffer(self.CanvasIdentifier.ID, self.ViewportCanvas)        
        self.Drawable.material:SetAlbedoTexture(self.CanvasIdentifier)
    end
end

function SurfaceViewport:SetDisableDepth(New)
    self.DisableDepth = New

    --print(New)
    self.Drawable.material.DepthTest = (not New)
end

function SurfaceViewport:UpdateDrawable(Parent)
    local TransformPos = Parent.Transform.Position:ToDream()
    local DisplaySide = self.DisplaySide:ToDream()

    self.Drawable:resetTransform()
    self.Drawable:translate(TransformPos)
    self.Drawable:lookTowards(DisplaySide)
    self.Drawable:translate(0,0,0.01)
    self.Drawable:scale(Parent.Size.X, Parent.Size.Y, Parent.Size.Z)
    self.Drawable:translate(0,0,1)
end

function SurfaceViewport:Update(dt)
    SurfaceViewport.super.Update(self, dt)

    local Parent = self.Parent ---@class Drawable3D
    if not Parent:IsA("Drawable3D") then return end

    Runtime.Renderer.ViewportManager.RenderViewport2D(self)
    self:UpdateDrawable(Parent)
end

return SurfaceViewport