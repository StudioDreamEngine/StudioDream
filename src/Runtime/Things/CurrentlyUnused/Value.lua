local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local Value = Things.Extend("Thing")

function Value:New() -- This is like, Instance values but combined into 1
    self.Value = nil
    self.Type = nil
end

function Value:Update(dt) 
    -- Make this change the audio volume depeding if this has a 3DObject or 2DObject as a parent
end

return Value