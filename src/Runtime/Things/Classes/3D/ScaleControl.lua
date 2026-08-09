-- Moveable axis control
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

---@class ScaleControl: Control3D
local ScaleControl = Things.Extend("Control3D")

function ScaleControl:GetPlane()
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

function ScaleControl:OnStart()
    self.InitalPos = self.Adornee.Position

    self.InitalOffset = self:GetPlane()
    self.NormalSide = self.Down.Thing
end

function ScaleControl:OnChange()
    local DistanceFrom = (self:GetPlane() - self.InitalOffset)
    local Snapped = self:Snap((DistanceFrom * self.NormalSide).Axis(), self.GridSnap)

    self.ControlChanged.Invoke(self.NormalSide, Snapped)
end

function ScaleControl:DefineAPI()
    ScaleControl.super.DefineAPI(self)
    
    self.Proxy.MakeCreatable()
end

function ScaleControl:new()
    self.InitalPos = Vector3.zero
    self.InitalOffset = Vector3.zero
    self.NormalSide = Vector3.zero

    self.Lookup = {
        [Vector3.zAxis] = Color.new(0,0,1,0.8),
        [-Vector3.zAxis] = Color.new(0,0,1,0.8),
        [Vector3.xAxis] = Color.new(1,0,0,0.8),
        [-Vector3.xAxis] = Color.new(1,0,0,0.8),
        [Vector3.yAxis] = Color.new(0,1,0,0.8),
        [-Vector3.yAxis] = Color.new(0,1,0,0.8)
    }

    self.Resource = "Internal/DefaultMeshes/ball.obj"

    ScaleControl.super.new(self)
end

function ScaleControl:UpdateAdorn(Axis, Adorn, Transform, CameraDistance)
    -- ...oh god
    Adorn:resetTransform()
    Adorn:translate((Transform.Position + (Axis * self.Adornee.Size)).ToDream())
    Adorn:lookTowards(-Axis.ToDream())
    Adorn:scale(CameraDistance)
    Adorn:translate(0,0,2)
    Adorn:rotateX(math.pi/2)
end

return ScaleControl