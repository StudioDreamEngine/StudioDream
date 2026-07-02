local StudioCamera = {}

local HoldingCamera = false
local CameraRotation = Vector2.zero
local CameraPosition = Vector3.zero

local MouseService = Runtime.Services.Service("MouseService") ---@class MouseService
local InputService = Runtime.Services.Service("InputService") ---@class InputService

local PrevDT

function StudioCamera.Init()
    InputService.MouseEvent:Connect(function(IsDown)
        if IsDown then
            MouseService.SetMouseMode(Enum.MouseMode.Locked)
        else
            MouseService.SetMouseMode(Enum.MouseMode.Free)
        end

        HoldingCamera = IsDown
    end, Enum.MouseButton.RightClick)

    InputService.MouseMoved:Connect(function(MouseObject)
        if (not HoldingCamera) then return end

        local Delta = MouseObject.Delta
        CameraRotation.X = CameraRotation.X + Delta.X/300
        CameraRotation.Y = CameraRotation.Y - Delta.Y/300
    end)
end

function StudioCamera.Update(dt)
    local Camera = Runtime.Things.Root:GetCamera()
    if (not Camera) then return end

    local KeyDownNum = InputService.KeyDownNumber

    local Forward = Camera.Transform.Forward * (KeyDownNum(Enum.InputCode.S) - KeyDownNum(Enum.InputCode.W))
    local Side = Camera.Transform.Side * (KeyDownNum(Enum.InputCode.D) - KeyDownNum(Enum.InputCode.A))
    local Direction = (Forward + Side).Unit()

    CameraPosition = CameraPosition + Direction*dt*4

    Camera:SetTransform(Transform3D.FromPosition(CameraPosition) * Transform3D.FromAngle(0, CameraRotation.X, 0) * Transform3D.FromAngle(CameraRotation.Y, 0, 0))
end

return StudioCamera