local StudioCamera = {}
local InputService

local HoldingCamera = false
local CameraRotation = Vector2.zero

function StudioCamera.Init()
    InputService = Runtime.Services.Service("InputService") ---@class InputService

    InputService.MouseDown:Connect(function(Button)
        if Button == Enum.MouseButton.RightClick then
            HoldingCamera = true
        end
    end)

    InputService.MouseUp:Connect(function(Button)
        if Button == Enum.MouseButton.RightClick then
            HoldingCamera = false
        end
    end)

    InputService.MouseMoved:Connect(function(MouseObject)
        if (not HoldingCamera) then return end

        local Delta = MouseObject.Delta
        CameraRotation.X = CameraRotation.X + Delta.X
        CameraRotation.Y = CameraRotation.Y + Delta.Y
    end)
end

function StudioCamera.Update(dt)
    local Camera = Runtime.Things.Root:GetCamera()

    Camera.
end

return StudioCamera