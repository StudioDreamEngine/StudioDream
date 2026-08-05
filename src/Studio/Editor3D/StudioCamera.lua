local StudioCamera = {}

local HoldingCamera = false
local CameraRotation = Vector2.zero
local CameraPosition = Vector3.zero
local MouseDelta = Vector2.zero

local MouseService = Runtime.Services.Service("MouseService") ---@class MouseService
local InputService = Runtime.Services.Service("InputService") ---@class InputService

local PrevDT = 0

function StudioCamera.Init()
    InputService.MouseEvent:Connect(function(IsDown)
        if IsDown then
            MouseService.SetMouseMode(Enum.MouseMode.Locked)
        else
            MouseService.SetMouseMode(Enum.MouseMode.Free)
            MouseDelta = Vector2.zero
        end

        HoldingCamera = IsDown
    end, Enum.MouseButton.RightClick)

    InputService.MouseMoved:Connect(function(MouseObject)
        if (not HoldingCamera) then return end

        local Delta = MouseObject.Delta
        MouseDelta = Delta
    end)
end

function StudioCamera.Update(dt)
    local sucess, error = pcall(function()
        PrevDT = dt
    
        local Camera = Runtime.Things.Root:GetCamera()   

        local KeyDownNum = InputService.KeyDownNumber

        if (not Camera) then return end
        if (not Camera.Transform) then printVerbose("Camera Transform was nil, this SHOULD NOT happen") return end

        local Forward = Camera.Transform.Forward * (KeyDownNum(Enum.InputCode.S) - KeyDownNum(Enum.InputCode.W))
        local Side = Camera.Transform.Side * (KeyDownNum(Enum.InputCode.D) - KeyDownNum(Enum.InputCode.A))
        local Direction = (Forward + Side).Unit()

        -- TODO: fix this fuckass random 200 number value >:3
        CameraRotation.X = CameraRotation.X + MouseDelta.X/200
        CameraRotation.Y = CameraRotation.Y - MouseDelta.Y/200

        CameraPosition = CameraPosition + Direction*dt*3

        local NewTransform = Transform3D.FromPosition(CameraPosition) * Transform3D.FromAngle(0, CameraRotation.X, 0) * Transform3D.FromAngle(CameraRotation.Y, 0, 0)
        
        Camera:SetTransform(NewTransform)

        --Camera:SetTransform(Camera.Transform.Lerp(NewTransform, dt*8))
    end)

    if not sucess then
        print(error)
    end
end

return StudioCamera