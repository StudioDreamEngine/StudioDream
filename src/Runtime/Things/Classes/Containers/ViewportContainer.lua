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
    if NewAdornee and NewAdornee:IsA("Viewport") then
        self.Adornee = NewAdornee

        if (not NewAdornee.RenderContainer) then
            NewAdornee.RenderContainer = self
        else
            print("RenderContainer of Viewport was not automatically set, as it already has a RenderContainer")
        end
    else
        self.Adornee = nil
    end
end

return ViewportContainer