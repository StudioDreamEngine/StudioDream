local Things = Runtime.Things

---@class Enviornment
local Enviornment = Things.Extend("Thing")

function Enviornment:Init()
    self.Explorer = {
        UseNewIcon = false,
        Icon = "world"
    }
end

function Enviornment:Update(dt) end

return Enviornment