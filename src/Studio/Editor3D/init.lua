-- Handles the 3D editor - Camera, Tools, etc
local Editor3D = {}

Editor3D.SelectionManager = require("Studio.Editor3D.SelectionManager")
Editor3D.ToolManager = require("Studio.Editor3D.ToolManager")

Editor3D.ZoomTo = Editor3D.SelectionManager.ZoomTo

Editor3D.Selecting = {}
Editor3D.OnSelect = Signal:New("SelectionSignal")
Editor3D.OnDeselect = Signal:New("UnSelectionSignal")

Editor3D.PropertyChanged = Signal:New("ChangedProperty")

Editor3D.GridSnap = 10
Editor3D.RotationSnap = 10

Editor3D.GridUpdated = Signal:New("GridUpdated")

function Editor3D.UpdateGrid(Name,ToWhat)
    Editor3D[Name.."Snap"] = ToWhat
    Editor3D.GridUpdated.Invoke()
end

function Editor3D.ToggleWindowOutside(Name,Visible)
    --Shared.QueueAbort("Mikl what the fuck is this function (Studio.Editor3D.ToggleWindowOutside) for")

    local WindowHandle = Studio.Layout.GetHandle(Name)
    Studio.Layout.ToggleWindow(WindowHandle, Visible)
end

function Editor3D.CloseInsertWindow(Object)
    local WindowHandle = Studio.Layout.GetHandle("InsertObject")

    Studio.Layout.MoveWindow(WindowHandle, Studio.Layout.GetMouseContext(WindowHandle.Container))
    Studio.Layout.ToggleWindow(WindowHandle, false)

    WindowHandle.TargetObject = nil
end

function Editor3D.GetDefaultTarget()
    return Editor3D.Selecting[1] or Runtime.Things.Root:GetEnvironment()
end

function Editor3D.Init()
    printVerbose("Initalizing Studio Editor")
    Editor3D.StudioCamera = require("Studio.Editor3D.StudioCamera")

    Editor3D.SelectionManager.Init()
    Editor3D.StudioCamera.Init()
    Editor3D.ToolManager.Init()
end

function Editor3D.Update(dt)
    Editor3D.ToolManager.Update(dt)
    Editor3D.StudioCamera.Update(dt)
end

return Editor3D