local SelectionManager = {}
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService

--local Editor3D

SelectionManager.ObjectPicker = false
SelectionManager.ObjectPickerEvent = Signal:New("GetThingToPutOnAProperty")

function SelectionManager.DeselectAll()
    if Editor3D.Selecting then -- 💀💀💀💀💀
        Editor3D.Selecting = {}
        Editor3D.OnDeselect.Invoke(Editor3D.Selecting)
    end

    SelectionManager.ObjectPicker = false
end

-- Select object, either for picker or not
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

-- Select object itself
function SelectionManager.SelectObjectInternal(Thing)
    if InputService.KeyDown(Enum.InputCode.LeftShift) then
        if table.find(Editor3D.Selecting, Thing) then return end
        
        table.insert(Editor3D.Selecting, Thing)
    else
        Editor3D.Selecting = {Thing}
    end

    Editor3D.OnSelect.Invoke(Thing)
end

function SelectionManager.Init()
    local SelectionPriority = Runtime.SelectionPriority
    Editor3D = Studio.Editor3D
    ToolManager = Editor3D.ToolManager

    ---@diagnostic disable-next-line: duplicate-set-field
    Runtime.LoadProjectCallback = function()
        SelectionManager.DeselectAll()
        Studio.Layout.CallHandle("Explorer", "Redraw")
    end

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
            SelectionManager.DeselectAll()
        end
    end, 1, function(IsDown)
        return IsDown
    end)
end

return SelectionManager