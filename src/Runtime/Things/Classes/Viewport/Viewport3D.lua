local Things = Runtime.Things
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

---@class Viewport3D: Viewport
local Viewport3D = Things.Extend("Viewport")

function Viewport3D:new()
    Viewport3D.super.new(self)

    self.Hovering = false
    self.SinkHovering = false

    Runtime.InterfaceManager.RegisterButton(self.UUID)

    self.Click = Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering then return end

        SpatialService.Raycast(Camera.Position, Camera:GetMouseRay()*300, self.AdornObject)
    end)

    self.Canvases = Dream:newCanvases()
    self.Canvases:init(10,10)
end

function Viewport3D:DefineAPI()
    Viewport3D.super.DefineAPI(self)
    
    self.Proxy.Icon("Viewport_3D")
    self.Proxy.MakeCreatable()
end

function Viewport3D:SetAbsoluteSize(New)
    Viewport3D.super.SetAbsoluteSize(self, New)

    if New.X > 0 then
        self.Canvases:unloadCanvasSet()
        self.Canvases:init(New.X, New.Y)
    end
end

function Viewport3D:GetWorld()
    assert(self.RenderContainer, "RenderContainer not specified before rendering started!")

    return self.RenderContainer.DreamWorld
end

function Viewport3D:OnRemove()
    Viewport3D.super.OnRemove(self)

    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

-- Pain
function Viewport3D:GetCamera()
    return self:GetTarget().Camera
end

function Viewport3D:Update(dt)
    Viewport3D.super.Update(self,dt)
end

return Viewport3D