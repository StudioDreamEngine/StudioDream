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

-- Pain
function Environment:GetCamera()
    return self.Camera or self.Viewport.Camera
end

function Environment:Update(dt)
    Environment.super.Update(self, dt)
end

return Environment