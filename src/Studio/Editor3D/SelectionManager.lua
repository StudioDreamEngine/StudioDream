local SelectionThing = {}
local Things = Runtime.Things

local CurrentlySelecting

function SelectionThing.Init()
    local InputService = Runtime.Services.Service("InputService") ---@class InputService

    local ToolManager = Studio.Editor3D.ToolManager

    InputService.MouseDown:Connect(function()
        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment:GetCamera() ---@class Camera

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if CurrentlySelecting then
            CurrentlySelecting:SetOutline(false)
            --MoveControl.Adornee = nil
        end

        if Raycast then
            CurrentlySelecting = Raycast.Thing
            CurrentlySelecting:SetOutline(true)

            ToolManager.Select(CurrentlySelecting)
        end
    end, Enum.MouseButton.LeftClick)
end

return SelectionThing