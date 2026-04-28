local Things = Runtime.Things

---@class Environment: Thing
local Environment = Things.Extend("Thing")

local Raycast = Dream:getExtension("raytrace")

function Environment:new()
    Environment.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Environment"
    }

    self.Viewport = nil
    self.Camera = nil
end

function Environment:Raycast(origin, direction, onlyRaytraceMeshes)
   return Raycast:cast(Runtime.Backend3D.GetWorld(), origin.ToDream(), direction.ToDream(), onlyRaytraceMeshes)
end

-- Pain
function Environment:GetCamera()
    return self.Camera or self.Viewport.Camera
end

function Environment:Update(dt)
    Environment.super.Update(self, dt)
end

return Environment