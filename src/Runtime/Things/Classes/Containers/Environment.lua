local Things = Runtime.Things

---@class Environment
local Environment = Things.Extend("Thing")

function Environment:new()
    Environment.super.new(self)

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Environment"
    }
end

function Environment:Update(dt) end

return Environment