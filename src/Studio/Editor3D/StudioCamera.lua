local StudioCamera = {}

local PanningCamera = false

local CameraFocus = Vector3.zAxis
local CameraPosition = Vector3.zero
local CameraTransform = Transform3D.FromPosition(0,0,0)

local MouseDelta = Vector2.zero

local MouseService = Runtime.Services.Service("MouseService") ---@class MouseService
local InputService = Runtime.Services.Service("InputService") ---@class InputService

StudioCamera.Thing = nil

-- ass function :fire:
function StudioCamera.SetTransform(Eye, Focus)
    CameraFocus = Focus
    CameraPosition = Eye
end

function StudioCamera.Init()
    InputService.MouseEvent:Connect(function(IsDown)
        if IsDown and Runtime.SelectionPriority.InViewport then
            MouseService.SetMouseMode(Enum.MouseMode.Locked)
        else
            MouseService.SetMouseMode(Enum.MouseMode.Free)
            MouseDelta = Vector2.zero
        end

        PanningCamera = IsDown and Runtime.SelectionPriority.InViewport
    end, Enum.MouseButton.RightClick)

    InputService.MouseMoved:Connect(function(MouseObject)
        if not (PanningCamera) then return end

        local Delta = MouseObject.Delta
        MouseDelta = Delta
    end)
end

function StudioCamera.Update(dt)
    local sucess, error = pcall(function()
        local Camera = Runtime.Things.Root:GetCamera()   

        if StudioCamera.Thing~=Camera then
            StudioCamera.Thing = Camera
        end

        local KeyDownNum = InputService.KeyDownNumber

        if (not Camera) then return end
        if (not Camera.Transform) then printVerbose("Camera Transform was nil, this SHOULD NOT happen") return end

        local Forward = CameraTransform.Forward * (KeyDownNum(Enum.InputCode.S) - KeyDownNum(Enum.InputCode.W))
        local Side = CameraTransform.Side * (KeyDownNum(Enum.InputCode.D) - KeyDownNum(Enum.InputCode.A))
        local Up = CameraTransform.Up * (KeyDownNum(Enum.InputCode.E) - KeyDownNum(Enum.InputCode.Q))
        local Direction = (Forward + Side + Up):Unit() * dt * 3

        -- Fuckass focus code
        if PanningCamera then
            local CDirection = (CameraFocus - CameraPosition):Unit()

            local SideV = (CameraTransform.Side * MouseDelta.X/200)
            local UpV = (CameraTransform.Up * MouseDelta.Y/200)

            CameraFocus = CameraPosition + (CDirection - UpV + SideV) + Direction
        else
            CameraFocus = CameraFocus + Direction
        end

        --(CameraTransform.Up * MouseDelta.Y/200) - 
        CameraPosition = CameraPosition + Direction

        CameraTransform = Transform3D.LookAt(CameraPosition, CameraFocus)
        Camera:SetTransform(CameraTransform)
    end)

    if not sucess then
        print(error)
    end
end

return StudioCamera