local Things = Runtime.Things

---@class HUD
local HUD = Things.Extend("Thing")

function HUD:new()
    HUD.super.new(self)

    self.Explorer = {
        Visible = true,
        
        Icon = "HUD"
    }
end

function HUD:Update(dt) end

return HUD