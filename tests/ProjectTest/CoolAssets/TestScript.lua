local Environment = root:GetEnvironment()

print("Start script")

local HoldingCamera = false
local CameraRotation = Vector2.zero

local MouseService = service("MouseService") ---@class MouseService
local RenderService = service("RenderService") ---@class RenderService
local InputService = service("InputService") ---@class InputService

Environment:FindFirstChild("Audio"):Play()

local Camera = Environment:FindFirstChild("Camera") ---@class Camera
local Character = Environment:FindFirstChild("Primitive") ---@class Primitive

Character:SetDynamic(true)

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

RenderService.OnStep:Connect(function()
    Camera:SetTransform(Character.Transform * Transform3D.FromAngle(0, CameraRotation.X, 0) * Transform3D.FromAngle(CameraRotation.Y, 0, 0) * Transform3D.FromPosition(0,0,5))
end)