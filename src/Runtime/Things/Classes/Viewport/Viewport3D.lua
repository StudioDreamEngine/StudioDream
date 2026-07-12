local Things = Runtime.Things

---@class Viewport3D: Viewport
local Viewport3D = Things.Extend("Viewport")

function Viewport3D:new()
    Viewport3D.super.new(self)
end

function Viewport3D:DefineAPI()
    Viewport3D.super.DefineAPI(self)
    
    self.Proxy.Icon("Viewport_3D")

    self.Proxy.MakeCreatable()
end

function Viewport3D:GetWorld()
    assert(self.RenderContainer, "RenderContainer not specified before rendering started!")

    return self.RenderContainer.DreamWorld
end

-- Pain
function Viewport3D:GetCamera()
    return self:GetTarget().Camera or Dream.camera
end

function Viewport3D:Update(dt)
    Viewport3D.super.Update(self,dt)
end

return Viewport3D