local Things = Runtime.Things

---@class PhysicsPosition: PhysicsForce
local PhysicsPosition = Things.Extend("PhysicsForce")

function PhysicsPosition:new()
    PhysicsPosition.super.new(self)
    
    self.Force = Vector3.zero
    self.Stiffness = 10
    self.Damping = 5
    self.Position = Vector3.zero

    self.CurrentEnvironment = nil
end

function PhysicsPosition:DefineAPI()
    PhysicsPosition.super.DefineAPI(self)

    self.Proxy.Property("Vector3 Position","number Damping","number Stiffness")
    self.Proxy.Group("Physics", "Position","Damping", "Stiffness")
    self.Proxy.RemoveProperty("Force")
    self.Proxy.Icon("PhysicsPosition")

    self.Proxy.MakeCreatable()
end

function PhysicsPosition:Update(dt)
    PhysicsPosition.super.Update(self, dt)

    self.CurrentEnvironment = self:FindFirstAncestorOfClass("Environment")

    if self.Parent:IsA("Drawable3D") and self.CurrentEnvironment then
        local Parent = self.Parent
        local Offset = self.Position - Parent.Transform.Position
        local Spring = Offset * self.Stiffness - Parent.Velocity * self.Damping

        self.Force = (Spring + self.CurrentEnvironment.Gravity:Abs()) * Parent.Mass
        Parent.Velocity = Parent.Velocity + (self.Force / Parent.Mass) * dt
    end
end

return PhysicsPosition