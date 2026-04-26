local Things = Runtime.Things

---@class Environment
local Environment = Things.Extend("Thing")

local Raycast = Dream:getExtension("raytrace")

function Environment:new()
    Environment.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Environment"
    }

    self.Camera = nil -- TODO
    self.Viewport = nil
end

-- TODO: Should we even have a camera, or should it be a part of Viewport3D?
function Environment:SetCamera(NewCamera)
    if (not self.Viewport) then
        error("No viewport set yet! Make sure its set before the camera is set")
    end

    NewCamera.Viewport = self.Viewport
    self.Camera = NewCamera
end

function Environment:Raycast(origin, direction, onlyRaytraceMeshes)
   return Raycast:cast(Runtime.Backend3D.GetWorld(), origin.ToDream(), direction.ToDream(), onlyRaytraceMeshes)
end

function Environment:Update(dt) end

return Environment