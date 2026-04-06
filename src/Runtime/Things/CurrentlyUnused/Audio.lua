local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local Audio = Things.Extend("Thing")

function Audio:new() 
    self.AudioFile = nil
    self.Volume = 100
    self.Playbackspeed = 1

    self.ExplorerVisible = true
end

function Audio:Update(dt) 
    -- Make this change the audio volume depeding if this has a 3DObject or 2DObject as a parent
end

return Audio