-- Base class for thing
local Thing = Object:extend()

function Thing:New()
    self.Children = {}
end

function Thing:AddChild(NewParent)
    table.insert(NewParent.Children, self.Name)
end

return Thing