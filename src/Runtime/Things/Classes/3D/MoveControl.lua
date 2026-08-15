-- Moveable axis control
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

---@class MoveControl: Control3D
local MoveControl = Things.Extend("Control3D")

function MoveControl:GetPlane()
    local Camera = Things.Root:GetCamera()
    local MouseRay = Camera:GetMouseRay()
    local Transform = self.Adornee.Transform

    local Rays = {
        Z = Camera:LocalRayDirectionToPlane(self.InitalPos, Transform.Side, MouseRay) * Vector3.zAxis,
        Y = Camera:LocalRayDirectionToPlane(self.InitalPos, Transform.Forward, MouseRay) * Vector3.yAxis, -- Idk if Y should use the forward vector... oh well!
        X = Camera:LocalRayDirectionToPlane(self.InitalPos, Transform.Forward, MouseRay) * Vector3.xAxis
    }

    return Rays.X + Rays.Y + Rays.Z
end

function MoveControl:OnStart()
    self.InitalPos = self.Adornee.Position
    self.InitalOffset = self:GetPlane()
end

function MoveControl:OnChange()
    local MoveAxis = self.Down.Thing:Abs()
    local Value = (self:GetPlane() - self.InitalOffset) * MoveAxis
    self.ControlChanged.Invoke(self:Snap(Value, self.GridSnap))
end

function MoveControl:new()
    self.InitalPos = Vector3.zero
    self.InitalOffset = Vector3.zero

    self.Lookup = {
        [Vector3.zAxis] = Color.new(0,0,1,0.8),
        [Vector3.xAxis] = Color.new(1,0,0,0.8),
        [Vector3.yAxis] = Color.new(0,1,0,0.8),
    }

    self.Resource = "Internal/DefaultMeshes/arrow.obj"

    MoveControl.super.new(self)
end

function MoveControl:DefineAPI()
    MoveControl.super.DefineAPI(self)
    
    self.Proxy.MakeCreatable()
end

function MoveControl:UpdateAdorn(Axis, Adorn, Transform, CameraDistance)
    -- ...oh god
    Adorn:resetTransform()
    Adorn:translate((Transform.Position + (Axis * self.Adornee.Scale)):ToDream())
    Adorn:lookTowards(-Axis:ToDream())
    Adorn:scale(CameraDistance)
    Adorn:translate(0,0,2)
    Adorn:rotateX(math.pi/2)
end

return MoveControl