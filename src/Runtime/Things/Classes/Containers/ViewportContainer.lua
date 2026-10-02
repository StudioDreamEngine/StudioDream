local Things = Runtime.Things

---@class ViewportContainer: Thing
local ViewportContainer = Things.Extend("Thing")

function ViewportContainer:new()
    ViewportContainer.super.new(self)

    self.Adornee = nil
end

function ViewportContainer:DefineAPI()
    ViewportContainer.super.DefineAPI(self)
    self.Proxy.Icon("HUD")

    self.Proxy.SetCategory("Containers")

    self.Proxy.MakeCreatable()
end

return ViewportContainer