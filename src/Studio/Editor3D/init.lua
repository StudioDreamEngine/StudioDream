-- Handles the 3D editor - Camera, Tools, etc
local Editor3D = {}
local SelectionManager = require("Studio.Editor3D.SelectionManager")

function Editor3D.Init()
    SelectionManager.Init()
end

function Editor3D.Update(dt)
    
end

return Editor3D