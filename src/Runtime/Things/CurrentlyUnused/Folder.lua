local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local Folder = Things.Extend("Thing")

-- This would be Model and Folder combined

function Folder:New() 
    self.LockObjectsIn = false -- Basically the model functionally that moves everything like 1 being, Maybe make this for outlines too? idk
    self.ExplorerVisible = true
end

function Folder:Update(dt) 
    -- Make this change the audio volume depeding if this has a 3DObject or 2DObject as a parent
end

return Folder