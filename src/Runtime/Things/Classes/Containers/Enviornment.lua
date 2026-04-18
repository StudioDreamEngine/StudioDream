local Things = Runtime.Things

---@class Enviornment
local Enviornment = Things.Extend("Thing")

function Enviornment:new()
    Enviornment.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Enviornment"
    }
end

function Enviornment:Update(dt) end

return Enviornment