-- Moveable axis control
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService
local SpatialService = Runtime.Services.Service("SpatialService") ---@class SpatialService

local SelectionPriority = Runtime.SelectionPriority

---@class MoveControl: Control3D
local MoveControl = Things.Extend("Control3D")

local Lookup = {
    Vector3.zAxis,
    -Vector3.zAxis,
    Vector3.xAxis,
    -Vector3.xAxis,
    Vector3.yAxis,
    -Vector3.yAxis
}

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

function MoveControl:ConnectEvents()
    print("Connect move events")

    self.MouseEvent = SelectionPriority.BindSignal(function(IsDown)
        if IsDown then
            self.StartMove.Invoke()

            self.Down = self.Hovering
            self.InitalPos = self.Adornee.Position
            self.InitalOffset = self:GetPlane()
        else
            self.Down = false 
            self.EndMove.Invoke() 
        end
    end, 2, function ()
        return self.Hovering or self.Down
    end)

    self.MouseMoved = InputService.MouseMoved:Connect(function(MouseObject)
        if (not self.Down) then return end

        self.OnMove.Invoke((self:GetPlane() - self.InitalOffset) * self.Down.Abs())
    end)
end

function MoveControl:DisconnectEvents()
    SelectionPriority.UnbindSignal(self.MouseEvent)
    self.MouseMoved:Disconnect()
end

function MoveControl:new()
    MoveControl.super.new(self)

    self.OnMove = Signal:New("Control")
    self.EndMove = Signal:New("EndControl")
    self.StartMove = Signal:New("StartControl")

    self.Down = false
    self.Hovering = nil

    self.InitalPos = Vector3.zero
    self.InitalOffset = Vector3.zero

    self.Resource = nil

    self:ConnectEvents()

    for _, Axis in pairs(Lookup) do
        self.Adorns[Axis] = Runtime.Backend3D.LoadAdorn(self.Resource or "Internal/DefaultMeshes/arrow.obj", self.AdornObject, Axis)
    end
end

function MoveControl:DefineAPI()
    MoveControl.super.DefineAPI(self)
    
    self.Proxy.MakeCreatable()
end

function MoveControl:OnRemove()
    Runtime.Backend3D.RemoveAdorn(self.AdornObject.UUID)
    self:DisconnectEvents()

    MoveControl.super.OnRemove(self)
end

function MoveControl:Update(dt)
    if (not self.Adornee) then return end

    ---@class Camera
    local Camera = Things.Root:GetCamera()
    if (not Camera) then return end

    local Transform = self.Adornee.Transform

    local CameraDistance = (Transform.Position - Camera.Position).Magnitude()
    CameraDistance = math.sqrt(CameraDistance) / 8 -- Black magic, Literally black magic.

    local Hovering = SpatialService.Raycast(Camera.Position, Camera:GetMouseRay()*400, self.AdornObject)

    self.Hovering = Hovering and Hovering.Thing

    for Axis, Adorn in pairs(self.Adorns) do
        -- ...oh god
        Adorn:resetTransform()
        Adorn:translate((Transform.Position + (Axis * self.Adornee.Scale)).ToDream())
        Adorn:lookTowards(-Axis.ToDream())
        Adorn:scale(CameraDistance)
        Adorn:translate(0,0,2)
        Adorn:rotateX(math.pi/2)
    end
end

return MoveControl