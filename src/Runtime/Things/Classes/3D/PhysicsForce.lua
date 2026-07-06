local Things = Runtime.Things

---@class PhysicsForce: Thing
local PhysicsForce = Things.Extend("Thing")

function PhysicsForce:new()
    PhysicsForce.super.new(self)
    
    self.Force = Vector3.zero
end

function PhysicsForce:DefineAPI()
    PhysicsForce.super.DefineAPI(self)

    self.Proxy.Property("Vector3 Force")
    self.Proxy.Group("Physics", "Force")

    self.Proxy.MakeCreatable()
end

function PhysicsForce:Update(dt)
    PhysicsForce.super.Update(self, dt)

    if self.Parent:IsA("Drawable3D") then
        local Body = self.Parent.PhysicsBody
        if (not Body) then return end

        Body:applyCentralForce((self.Force/self.Parent.Mass).ToBullet())
    end
end

return PhysicsForce