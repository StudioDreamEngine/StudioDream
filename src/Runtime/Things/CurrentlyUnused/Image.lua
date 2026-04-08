local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local Image = Things.Extend("Thing")

function Image:new() 
    self.Image = nil
    self.Transparency = 0
    self.Visible = true

    self.Adorn = nil
    self.ExplorerVisible = true
end

function Image:Update(dt) 
    
end

return Image