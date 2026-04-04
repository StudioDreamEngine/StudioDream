local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local Folder = Things.Extend("Thing")

function Folder:New() 
    
    self.LockObjects = false
    self.ExplorerVisible = true
end

function Folder:Update(dt) 
    -- Make this change the audio volume depeding if this has a 3DObject or 2DObject as a parent
end

return Folder