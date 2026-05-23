local Things = Runtime.Things
local Backend3D = Runtime.Backend3D

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

    self.DreamWorld = Backend3D:CreateWorld()
    self.DreamWorld.IsEnv = true
end

function Environment:Raycast(origin, direction)
    return Runtime.Backend3D.Raycast(origin, direction, self.DreamWorld)
end

function Environment:ManageWorld()
    self.DreamWorld.objects = {}

    for _, Child in pairs(self:GetDescendants()) do
        if Child:IsA("Drawable3D") then
            self.DreamWorld.objects[Child.UUID] = Child.Drawable
        end
    end
end

function Environment:Update(dt)
    Environment.super.Update(self, dt)

    self:ManageWorld()
    self.Camera.Viewport = self.Viewport
end

return Environment