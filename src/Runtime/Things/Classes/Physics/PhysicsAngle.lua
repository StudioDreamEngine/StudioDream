local Things = Runtime.Things

---@class PhysicsAngle: Thing
local PhysicsAngle = Things.Extend("Thing")

function PhysicsAngle:new()
    PhysicsAngle.super.new(self)
    
    self.TargetAngle = Transform3D.FromAngle(math.pi/2,0,0)
    self.Dampening = 2
    self.Stiffness = 8
end

function PhysicsAngle:DefineAPI()
    PhysicsAngle.super.DefineAPI(self)

    self.Proxy.SetCategory("Physics")

    self.Proxy.Property("Transform3D TargetAngle","number Dampening","number Stiffness")
    self.Proxy.Group("Physics", "TargetAngle","Dampening", "Stiffness")

    self.Proxy.Icon("PhysicsAngle")

    self.Proxy.MakeCreatable()
end

function PhysicsAngle:Update(dt)
    PhysicsAngle.super.Update(self, dt)

    if self.Parent:IsA("Drawable3D") then
        local Body = self.Parent.PhysicsBody
        if (not Body) then return end

        local Current = self.Parent.Transform.Forward:Unit()
        local Target = self.TargetAngle.Forward:Unit()

        -- https://stackoverflow.com/questions/77132252/unity-quaternion-lookrotationx-and-quaternion-fromtorotationvector3-forward
        local Angle = Current:Angle(Target) / 2

        local Axis = Current:Cross(Target):Unit()
        Axis = Axis * math.sin(Angle)

        local AngularVelocity = Vector3.FromBullet(Body:getAngularVelocity())
        local Rotation = ((Axis * self.Stiffness) - (AngularVelocity * self.Dampening)) * dt * 8

        Body:applyTorque(Rotation:ToBullet())
    end
end

return PhysicsAngle