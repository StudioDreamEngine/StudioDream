---@type Dream
local lib = _3DreamEngine

local DefaultRuntimeMaterial = Runtime.Things.New("Material")

function lib:newMaterial()
    return DefaultRuntimeMaterial    
end