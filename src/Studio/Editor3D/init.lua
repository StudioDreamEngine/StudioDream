-- Handles the 3D editor - Camera, Tools, etc
local Editor3D = {}
local SelectionManager = require("Studio.Editor3D.SelectionManager")

local Tools

function Editor3D.Init()
    SelectionManager.Init()

    --[[Tools = {
        Move = require("Studio.Editor3D.Tools.Move")
    }]]
end

function Editor3D.Update(dt)
    
end

return Editor3D