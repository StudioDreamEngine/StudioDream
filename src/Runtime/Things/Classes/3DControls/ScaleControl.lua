-- Moveable axis control
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService
local SelectionPriority = Runtime.SelectionPriority

---@class ScaleControl: Control3D
local ScaleControl = Things.Extend("Control3D")

local Lookup = {
    Vector3.zAxis,
    -Vector3.zAxis,
    Vector3.xAxis,
    -Vector3.xAxis,
    Vector3.yAxis,
    -Vector3.yAxis
}

function ScaleControl:GetPlane()
    local Camera = Things.Root:GetCamera()
    local MouseRay = Camera:GetMouseRay()
    local Transform = self.Adornee.Transform

    local Rays = {
        Z = Camera:LocalRayDirectionToPlane(self.InitalPos, Transform.Side, MouseRay) * Vector3.zAxis,
        Y = Camera:LocalRayDirectionToPlane(self.InitalPos, Transform.Forward, MouseRay) * Vector3.yAxis, -- Idk if Y should use the forward vector... whatever!
        X = Camera:LocalRayDirectionToPlane(self.InitalPos, Transform.Forward, MouseRay) * Vector3.xAxis
    }

    return Rays.X + Rays.Y + Rays.Z
end

function ScaleControl:ConnectEvents()
    print("Connect move events")

    self.MouseEvent = SelectionPriority.BindSignal(function(IsDown)
        if IsDown then
            self.StartScale.Invoke()

            self.Down = self.Hovering

            self.InitalPos = self.Adornee.Position

            self.InitalOffset = self:GetPlane()
            self.NormalSide = self.Down
        else
            self.Down = false 
            self.EndScale.Invoke() 
        end
    end, 2, function ()
        return self.Hovering or self.Down
    end)

    self.MouseMoved = InputService.MouseMoved:Connect(function(MouseObject)
        if (not self.Down) then return end

        local DistanceFrom = (self:GetPlane() - self.InitalOffset)
        self.OnMove.Invoke(self.NormalSide, (DistanceFrom * self.Down).Axis())
    end)
end

function ScaleControl:DisconnectEvents()
    SelectionPriority.UnbindSignal(self.MouseEvent)
    self.MouseMoved:Disconnect()
end

function ScaleControl:new()
    ScaleControl.super.new(self)

    self.OnMove = Signal:New("Control")
    self.EndScale = Signal:New("EndControl")
    self.StartScale = Signal:New("StartControl")

    self.InitalPos = Vector3.zero
    self.InitalOffset = Vector3.zero
    self.NormalSide = Vector3.zero

    --[[
        I dont like having to assign all of these to variables, we should find a way to be able to clean these up more automatically

        Perhaps there can be a third argument to say which object a signal is tied to, and you can directly disconnect all signals under that object?
        idk
    ]]
    self:ConnectEvents()

    for _, Axis in pairs(Lookup) do
        self.Adorns[Axis] = Runtime.Backend3D.LoadAdorn("Internal/DefaultMeshes/ball.obj", self.AdornObject, Axis)
    end
end

function ScaleControl:OnRemove()
    Runtime.Backend3D.RemoveAdorn(self.AdornObject.UUID)
    self:DisconnectEvents()

    ScaleControl.super.OnRemove(self)
end

function ScaleControl:Update(dt)
    if (not self.Adornee) then return end

    ---@class Camera
    local Camera = Things.Root:GetCamera()
    if (not Camera) then return end

    local Transform = self.Adornee.Transform

    local CameraDistance = (Transform.Position - Camera.Position).Magnitude()
    CameraDistance = math.sqrt(CameraDistance) / 8 -- Black magic, Literally black magic.

    local Hovering = Runtime.Backend3D.Raycast(Camera.Position, Camera:GetMouseRay()*400, self.AdornObject)

    self.Hovering = Hovering and Hovering.Thing

    for Axis, Adorn in pairs(self.Adorns) do
        -- ...oh god
        Adorn:resetTransform()
        Adorn:translate((Transform.Position + (Axis * self.Adornee.Size)).ToDream())
        Adorn:lookTowards(-Axis.ToDream())
        Adorn:scale(CameraDistance)
        Adorn:translate(0,0,2)
        Adorn:rotateX(math.pi/2)
    end
end

return ScaleControl