-- My idea for this is someth like the list layouts, using the constraint system
---@class Template: Thing
local Template = Things.Extend("Thing")

function Template:new()
    Template.super.new(self)

    error("Template class is not creatable")
end

function Template:Update(dt)
    
end

return Template