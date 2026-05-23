local SelectionManager = {}
local Things = Runtime.Things

local Editor3D
local ToolManager
local LastSelection    

SelectionManager.ObjectPicker = false
SelectionManager.ObjectPickerEvent = Signal:New("GetThingToPutOnAProperty")

function SelectionManager.DeselectObject()
    if Editor3D.Selecting then -- 💀💀💀💀💀
        if Editor3D.Selecting.SetOutline then Editor3D.Selecting:SetOutline(false) end
        local Tree = Studio.Layout.GetWindow("Explorer").Tree
        local ObjNode = Tree[Editor3D.Selecting]

        if ObjNode then ObjNode.BackgroundColor = Studio.Theme.Secondary end

        -- Editor3D.OnDeselect.Invoke()
    end

    SelectionManager.ObjectPicker = false
    ToolManager.Deselect()
end

function SelectionManager.SelectObject(Thing)
    if LastSelection ~= Thing then
        SelectionManager.DeselectObject()
    end

    if not SelectionManager.ObjectPicker then
        Editor3D.Selecting = Thing
        
        if Editor3D.Selecting.SetOutline then
            Editor3D.Selecting:SetOutline(true)
        end

        LastSelection = Editor3D.Selecting

        ToolManager.Select(Editor3D.Selecting)
        Editor3D.OnSelect.Invoke(Editor3D.Selecting)

        local Tree = Studio.Layout.GetWindow("Explorer").Tree
        local ObjNode = Tree[Thing]
        
        if ObjNode then  
            ObjNode.BackgroundColor = Studio.Theme.Selecting
        end
    else
        SelectionManager.ObjectPickerEvent.Invoke(Thing)
    end
end

function SelectionManager.Init()
    local SelectionPriority = Runtime.SelectionPriority
    Editor3D = Studio.Editor3D
    ToolManager = Editor3D.ToolManager

    SelectionPriority.BindSignal(function(IsDown)
        if (not IsDown) then return end

        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment.Camera ---@class Camera

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if Raycast then -- IF STATEMENTS CHAOS!! AHHHH!!
            SelectionManager.SelectObject(Raycast.Thing)
        else
            SelectionManager.DeselectObject()
        end
    end, 1)
end

return SelectionManager