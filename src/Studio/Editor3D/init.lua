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