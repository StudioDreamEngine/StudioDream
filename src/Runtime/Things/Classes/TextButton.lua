local Things = Runtime.Things

-- We should maybe merge this and ImageButton, for now however this will be how it works
-- using @module here gives the lua language server a base type to use!
---@module 'Text'
local TextButton = Things.Extend("Text")

function TextButton:new()
    TextButton.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "textfield_rename"
    }

    self.Hovering = false
end

function TextButton:Update(dt)
    

    self.ColorMultiplier = 0
end

return TextButton