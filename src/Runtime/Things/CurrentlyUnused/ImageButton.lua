local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Button2D = Things.Extend("Text")

function Button2D:new()
    self.super:new()

    self.Explorer = {
        Visible = true,
        Icon = "picture"
    }
end

function Button2D:Draw()
    
end

return Button2D