---@type Dream
local lib = _3DreamEngine

function lib:newMaterial()
    return Runtime.Things.New("Material")  
end