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
end

function ViewportContainer:SetAdornee(NewAdornee)
    if NewAdornee:IsA("Viewport") then
        self.Adornee = NewAdornee
        NewAdornee.RenderContainer = self
    else
        print("Couldnt set Adornee, Adornee isnt a Viewport or subclass")
    end
end

return ViewportContainer