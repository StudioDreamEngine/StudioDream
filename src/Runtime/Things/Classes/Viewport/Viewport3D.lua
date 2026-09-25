local Things = Runtime.Things
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

---@class Viewport3D: Viewport
local Viewport3D = Things.Extend("Viewport")

function Viewport3D:new()
    Viewport3D.super.new(self)

    self.Hovering = false
    self.SinkHovering = false

    Runtime.InterfaceManager.RegisterButton(self.UUID)

    self.OnPick = Signal:New("OnPick")

    self.Click = Runtime.SelectionPriority.BindSignal(function()
        local Camera = self:GetCamera()
        local CastResult = self.RenderContainer:Raycast(Camera.Position, Camera:GetMouseRay()*300)

        self.OnPick.Invoke(CastResult, self)
    end, 1, function(IsDown)
        return IsDown
    end)

    self.Canvases = Dream:newCanvases()
    self.Canvases:init(10,10)

    self.AdornRay = nil ---@class CastResult
end

function Viewport3D:DefineAPI()
    Viewport3D.super.DefineAPI(self)
    
    self.Proxy.Icon("Viewport_3D")
    self.Proxy.MakeCreatable()
end

function Viewport3D:SetAbsoluteSize(New)
    Viewport3D.super.SetAbsoluteSize(self, New)

    if New.X > 0 and New.Y > 0 then
        self.Canvases:unloadCanvasSet()
        self.Canvases:init(New.X, New.Y)
    end
end

function Viewport3D:Present()
    assert(self.RenderContainer, "RenderContainer not specified before rendering started!")

    return self.RenderContainer:Present()
end

function Viewport3D:OnRemove()
    Viewport3D.super.OnRemove(self)

    Runtime.InterfaceManager.UnregisterButton(self.UUID)
    Runtime.SelectionPriority.UnbindSignal(self.Click)
end

-- Pain
function Viewport3D:GetCamera()
    return self:GetTarget().Camera
end

local VecHuge = Vector2.one * 100000

function Viewport3D:Update(dt)
    Viewport3D.super.Update(self,dt)

    local Camera = self:GetCamera()
    if (not Camera) then return end
    
    local SelectResult = SpatialService.Raycast(Camera.Position, Camera:GetMouseRay()*50, Runtime.Backend3D.GetAdorns())
    self.AdornRay = SelectResult
end

return Viewport3D