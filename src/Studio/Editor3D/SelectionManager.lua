local SelectionThing = {}
local Things = Runtime.Things

function SelectionThing.Init()
    local SelectionPriority = Runtime.SelectionPriority
    local Editor3D = Studio.Editor3D
    local ToolManager = Editor3D.ToolManager

    SelectionPriority.BindSignal(function(IsDown)
        if (not IsDown) then return end

        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment:GetCamera() ---@class Camera

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if Editor3D.Selecting then
            Editor3D.Selecting:SetOutline(false)
            ToolManager.Deselect()
           -- Editor3D.OnDeselect.Invoke()
        end

        if Raycast then
            Editor3D.Selecting = Raycast.Thing
            Editor3D.Selecting:SetOutline(true)

            ToolManager.Select(Editor3D.Selecting)
            Editor3D.OnSelect.Invoke(Editor3D.Selecting)
        end
    end, 1)
end

return SelectionThing