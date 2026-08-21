local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class Template: Thing
local Template = Things.Extend("Thing")

function Template:new()
    Template.super.new(self)
end

-- Resource set template
function Template:SetIdentifier(Identifier)
    -- ``self.Identifier`` should be the one saved and exposed to the property editor, ``self.Resource`` is the resource itself and should be used in the object
    self.Resource, self.Identifier = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, "Shader")
    if (not self.Resource) then return end -- LoadResourceFromIdentifier can return nil if the type is invalid or something else
end

function Template:Update(dt)
    
end

return Template