local SelectionThing = {}
local Things = Runtime.Things

local Editor3D
local ToolManager

SelectionThing.Selected = Signal:New("SomethingGotSelected")
SelectionThing.Unselected = Signal:New("SomethingGotUnselected")

local function DeselectThing()
    if Editor3D.Selecting then -- 💀💀💀💀💀
        SelectionThing.Unselected.Invoke(Editor3D.Selecting)
        Editor3D.Selecting:SetOutline(false)
        ToolManager.Deselect()
        -- Editor3D.OnDeselect.Invoke()
    end
end

function SelectionThing.Init()
    local SelectionPriority = Runtime.SelectionPriority
    Editor3D = Studio.Editor3D
    ToolManager = Editor3D.ToolManager
    local LastSelection = nil
    SelectionPriority.BindSignal(function(IsDown)
        if (not IsDown) then return end

        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment:GetCamera() ---@class Camera

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if Raycast and not Raycast.NotOnViewport then
            if LastSelection~=Editor3D.Selecting then
                SelectionThing.Selected.Invoke(Editor3D.Selecting)
                DeselectThing()
            end
            Editor3D.Selecting = Raycast.Thing
            LastSelection = Editor3D.Selecting
            Editor3D.Selecting:SetOutline(true)

            ToolManager.Select(Editor3D.Selecting)
            Editor3D.OnSelect.Invoke(Editor3D.Selecting)
        elseif Raycast and Raycast.NotOnViewport then-- 💀💀💀💀💀
            return
        else
            DeselectThing()
        end
    end, 1)
end

return SelectionThing