local SelectionManager = {}
local Things = Runtime.Things
local InputService = Runtime.Services.Service("InputService") ---@class InputService

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

function SelectionManager.ZoomTo()
    local Target = Editor3D.Selecting[1] ---@class Transformable3D
    if (not Target) or (not Target:IsA("Transformable3D")) then return end

    local Size = Target.Size or Vector3.one ---@class Vector3
    local StudioCamera = Editor3D.StudioCamera

    local Distance = Vector3.GetHigherAxis(Size)*2
    local Position = Target.Position ---@class Vector3

    local SnapThisShit = Position-StudioCamera.Thing.Transform.Forward*Distance
    
    StudioCamera.SetTransform(SnapThisShit,Position)
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

function SelectionManager.DuplicateAll()
    local ClonedObjects = {}

    for i,Object in pairs(Editor3D.Selecting) do
        if not Object.Proxy.Duplicatable then return end
        Object:Clone().Parent = Object.Parent
        table.insert(ClonedObjects,Object)
    end
    
    Editor3D.Selecting = ClonedObjects
end

function SelectionManager.DeleteAll()
    for i,Object in pairs(Editor3D.Selecting) do
        Object:Destroy()
    end
end

function SelectionManager.GroupAll()
    local FolderTo = Things.Create("Folder") {
        Parent = Editor3D.Selecting[1].Parent
    }

    for i,Object in pairs(Editor3D.Selecting) do
        if not Object.Proxy.Creatable then return end
        Object.Parent = FolderTo
    end
    
    SelectionManager.DeselectAll()
    SelectionManager.SelectObject(FolderTo)
end

function SelectionManager.UngroupAll()
    local ToSelect = {}

    for _,Object in pairs(Editor3D.Selecting) do
        if Object and Object:IsA("Folder") then
            for _,Child in pairs(Object:GetChildren()) do
                Child.Parent = Object.Parent
                table.insert(ToSelect,Child)
            end
            Object:Destroy()
        end
    end

    Editor3D.Selecting = ToSelect
end

function SelectionManager.Init()
    local SelectionPriority = Runtime.SelectionPriority
    Editor3D = Studio.Editor3D
    ToolManager = Editor3D.ToolManager

    ---@diagnostic disable-next-line: duplicate-set-field
    Runtime.LoadProjectCallback = function()
        SelectionManager.DeselectAll()
        --Studio.Layout.CallHandle("Explorer", "Redraw")
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