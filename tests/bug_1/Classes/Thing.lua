-- Base class for thing
local Thing = Object:extend()

function Thing:New()
    self.Children = {}
end

return Thing