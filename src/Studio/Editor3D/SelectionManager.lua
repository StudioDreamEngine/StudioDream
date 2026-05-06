local SelectionThing = {}
local Things = Runtime.Things

local CurrentlySelecting

function SelectionThing.Init()
    local InputService = Runtime.Services.Service("InputService") ---@class InputService

    ---@class MoveControl
    local MoveControl = Things.Create("MoveControl") {
        Parent = Things.Root.RootViewport
    }

    InputService.MouseDown:Connect(function()
        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment:GetCamera() ---@class Camera
        
        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if CurrentlySelecting then
            CurrentlySelecting:SetOutline(false)
        end

        if Raycast then
            CurrentlySelecting = Raycast.Thing
            CurrentlySelecting:SetOutline(true)
            print("Wow")

            MoveControl.Adornee = CurrentlySelecting
        end
    end, Enum.MouseButton.LeftClick)
end

return SelectionThing