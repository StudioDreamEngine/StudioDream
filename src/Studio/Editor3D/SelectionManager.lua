local SelectionThing = {}
local Things = Runtime.Things

SelectionThing.CurrentlySelecting = nil

function SelectionThing.Init()
    local SelectionPriority = Runtime.SelectionPriority
    local ToolManager = Studio.Editor3D.ToolManager

    SelectionPriority.BindSignal(function(IsDown)
        if (not IsDown) then return end

        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment:GetCamera() ---@class Camera

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if SelectionThing.CurrentlySelecting then
            SelectionThing.CurrentlySelecting:SetOutline(false)
            ToolManager.Deselect()
        end

        if Raycast then
            SelectionThing.CurrentlySelecting = Raycast.Thing
            SelectionThing.CurrentlySelecting:SetOutline(true)

            ToolManager.Select(SelectionThing.CurrentlySelecting)
        end
    end, 1)
end

return SelectionThing