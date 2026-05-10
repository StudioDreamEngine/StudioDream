-- Handles the 3D editor - Camera, Tools, etc
local Editor3D = {}

Editor3D.SelectionManager = require("Studio.Editor3D.SelectionManager")
Editor3D.ToolManager = require("Studio.Editor3D.ToolManager")

function Editor3D.Init()
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