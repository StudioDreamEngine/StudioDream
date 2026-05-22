local Things = Runtime.Things

---@class Environment: Thing
local Environment = Things.Extend("Thing")

function Environment:new()
    Environment.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Environment"
    }

    self.Viewport = nil
    self.Camera = nil
end

-- TODO: Move to Camera?
function Environment:Raycast(origin, direction)
    return Runtime.Backend3D.Raycast(origin, direction, Runtime.Backend3D.GetWorld())
end

function Environment:Update(dt)
    Environment.super.Update(self, dt)

    self.Camera.Viewport = self.Viewport
end

return Environment