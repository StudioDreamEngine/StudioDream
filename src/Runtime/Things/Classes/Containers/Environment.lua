local Things = Runtime.Things
local Backend3D = Runtime.Backend3D

local collisionConfiguration = Bullet.btDefaultCollisionConfiguration()
local dispatcher = Bullet.btCollisionDispatcher(collisionConfiguration)
local overlappingPairCache = Bullet.btDbvtBroadphase()
local solver = Bullet.btSequentialImpulseConstraintSolver()

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

    self.StepPhysics = false
    self.Gravity = Vector3.new(0,-10,0)

    self.DreamWorld = Backend3D:CreateWorld()
    self.DreamWorld.IsEnv = true

    self.PhysicsWorld = Bullet.btDiscreteDynamicsWorld(dispatcher, overlappingPairCache, solver, collisionConfiguration)
    self.PhysicsWorld:setGravity(self.Gravity.ToBullet())

    self.PhysicsBodies = {}
end

function Environment:DefineAPI()
    Environment.super.DefineAPI(self)

    self.Proxy.Icon("Environment")
    self.Proxy.Property("Vector3 Gravity", "boolean StepPhysics", "Thing Camera")
    
    self.Proxy.Group("Physics", "Gravity", "StepPhysics")
    self.Proxy.Group("Rendering", "Camera")

    self.Proxy.MakeCreatable()
end

function Environment:SetGravity(NewGravity)
    self.Gravity = NewGravity
    self.PhysicsWorld:setGravity(NewGravity.ToBullet())
end

function Environment:Raycast(origin, direction)
    return Runtime.Backend3D.Raycast(origin, direction, self.DreamWorld)
end

function Environment:RemoveBody(Child)
    if Child.PhysicsBody then
        self.PhysicsBodies[Child] = nil
        self.PhysicsWorld:removeRigidBody(Child.PhysicsBody)
    end
end

function Environment:HandlePhysicsHierachy(Child)
    if (not self.PhysicsBodies[Child]) then
        self.PhysicsBodies[Child] = true
        self.PhysicsWorld:addRigidBody(Child.PhysicsBody)
    end
end

function Environment:ManageWorldHierachy()
    self.DreamWorld.objects = {}
    local Descendants = {}

    for _, Child in pairs(self:GetDescendants()) do
        if Child:IsA("Drawable3D") then
            self.DreamWorld.objects[Child.UUID] = Child.Drawable

            if Child.PhysicsBody then
                self:HandlePhysicsHierachy(Child)
            end

            table.insert(Descendants, Child)
        end
    end

    return Descendants
end

function Environment:PostStep(Descendants)
    for _, Child in pairs(Descendants) do
        Child.Transform = Runtime.Phys.FromBullet(Child:GetPhysicsTransform())
    end
end

function Environment:Update(dt)
    Environment.super.Update(self, dt)

    local Descendants = self:ManageWorldHierachy()

    if self.StepPhysics then
        Profiler.Start("Step Simulation")

        self.PhysicsWorld:stepSimulation(dt, 2)
        self:PostStep(Descendants)

        Profiler.End()
    end

    if self.Camera then
        self.Camera.Viewport = self.Viewport
    end
end

return Environment