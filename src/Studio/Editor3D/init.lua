-- Handles the 3D editor - Camera, Tools, etc
local Editor3D = {}
local SelectionManager = require("Studio.Editor3D.SelectionManager")

Editor3D.ToolManager = require("Studio.Editor3D.ToolManager")

function Editor3D.Init()
    SelectionManager.Init()
    Editor3D.ToolManager.Init()
end

function Editor3D.Update(dt)
    Editor3D.ToolManager.Update(dt)
end

return Editor3D