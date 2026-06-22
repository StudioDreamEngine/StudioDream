local SelectionManager = {}
local Things = Runtime.Things

local Editor3D
local ToolManager
local LastSelection    

SelectionManager.ObjectPicker = false
SelectionManager.ObjectPickerEvent = Signal:New("GetThingToPutOnAProperty")

function SelectionManager.DeselectObject(DontInvoke)
    if Editor3D.Selecting then -- 💀💀💀💀💀
        if Editor3D.Selecting.SetOutline then Editor3D.Selecting:SetOutline(false) end

        Editor3D.Selecting = nil

        if (not DontInvoke) then
            Editor3D.OnDeselect.Invoke(Editor3D.Selecting)
        end
    end

    SelectionManager.ObjectPicker = false
    ToolManager.Deselect()
end

function SelectionManager.SelectObject(Thing)
    if not SelectionManager.ObjectPicker then
        SelectionManager.SelectObjectInternal(Thing)
    else
        if SelectionManager.ObjectPicker ~= Thing then 
            SelectionManager.ObjectPicker = false
            SelectionManager.ObjectPickerEvent.Invoke(Thing)
        end

        Runtime.Cursor.ChangeCursor("Main")
    end
end

function SelectionManager.SelectObjectInternal(Thing)
    if LastSelection ~= Thing then
        SelectionManager.DeselectObject(true)
    end

    Editor3D.Selecting = Thing
    LastSelection = Editor3D.Selecting

    Editor3D.OnSelect.Invoke(Editor3D.Selecting)
    
    if Thing:IsA("Drawable3D") then
        if Editor3D.Selecting.SetOutline then
            Editor3D.Selecting:SetOutline(true)
        end

        ToolManager.Select(Editor3D.Selecting)
    end
end

function SelectionManager.Init()
    local SelectionPriority = Runtime.SelectionPriority
    Editor3D = Studio.Editor3D
    ToolManager = Editor3D.ToolManager

    ---@diagnostic disable-next-line: duplicate-set-field
    Runtime.LoadProjectCallback = SelectionManager.DeselectObject

    SelectionPriority.BindSignal(function()
        local Environment = Things.Root:GetEnvironment() ---@class Environment
        local Camera = Environment.Camera ---@class Camera

        if (not Camera) then 
            print("Selection by mouse requires a camera") 
            return
        end

        local Raycast = Environment:Raycast(Camera.Position, Camera:GetMouseRay()*100)

        if Raycast then -- IF STATEMENTS CHAOS!! AHHHH!!
            SelectionManager.SelectObject(Raycast.Thing)
        else
            SelectionManager.DeselectObject()
        end
    end, 1, function(IsDown)
        return IsDown
    end)
end

return SelectionManager