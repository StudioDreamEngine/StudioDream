local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'Thing'
local Image = Things.Extend("Thing")

function Image:New() 
    self.ImageFile = nil
    self.Transparency = 0
    self.Visible = true

    self.Adornee = nil

    self.ExplorerVisible = true
end

-- Maybe Images could also have EditableImages functionality? 🤔

function Image:GetBuffer()

end

function Image:Update(dt) 
    -- TODO Erm idk
end

return Image