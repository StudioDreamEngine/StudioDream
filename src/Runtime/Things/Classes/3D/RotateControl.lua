-- Moveable axis control
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

---@class RotateControl: Control3D
local RotateControl = Things.Extend("Control3D")

function RotateControl:GetPlane()
    local Camera = Things.Root:GetCamera()
    local MouseRay = Camera:GetMouseRay()

    return Camera:LocalRayDirectionToPlane(self.InitalPos, self.AxisNormal, MouseRay):Unit():Tangents()
end

function RotateControl:GetRotation()
    return (self:GetPlane() * -self.AxisNormal):Axis()
end

function RotateControl:OnStart()
    self.InitalPos = self.Adornee.Position
    self.AxisNormal = self.Down.Thing

    self.InitialRotation = self:GetRotation()
end

function RotateControl:OnChange()
    self.ControlChanged.Invoke(self:GetRotation() - self.InitialRotation, self.AxisNormal)
end

function RotateControl:DefineAPI()
    RotateControl.super.DefineAPI(self)
    
    self.Proxy.MakeCreatable()
end

function RotateControl:new()
    self.InitalPos = Vector3.zero
    self.AxisNormal = Vector3.zero
    self.InitialRotation = 0

    self.Lookup = {
        [Vector3.zAxis] = Color.new(0,0,1,0.8),
        [Vector3.xAxis] = Color.new(1,0,0,0.8),
        [Vector3.yAxis] = Color.new(0,1,0,0.8),
    }

    self.Resource = "Internal/DefaultMeshes/torus.obj"

    RotateControl.super.new(self)
end

function RotateControl:UpdateAdorn(Axis, Adorn, Transform, CameraDistance)
    -- ...oh god
    Adorn:resetTransform()
    Adorn:translate(Transform.Position:ToDream())
    Adorn:lookTowards(-Axis:ToDream())
    Adorn:scale(CameraDistance*2)
    Adorn:rotateX(math.pi/2)
end

return RotateControl