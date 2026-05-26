local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class Template: Thing
local Template = Things.Extend("Thing")

function Template:new()
    Template.super.new(self)
end

function Template:Update(dt)
    
end

return Template