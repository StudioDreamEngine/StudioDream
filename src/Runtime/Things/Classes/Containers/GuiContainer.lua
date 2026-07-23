local Things = Runtime.Things

---@class GuiContainer: ViewportContainer
local GuiContainer = Things.Extend("ViewportContainer")

function GuiContainer:ProcessInvalidation(Origin)
    for _, v in pairs(self:GetChildren()) do
        if v:IsA("BaseGui") then
            v:ProcessInvalidation(Origin)
        end
    end
end

function GuiContainer:DefineAPI()
    self.super.DefineAPI(self)

    self.Proxy.Creatable = false
    self.Proxy.MakeNonDuplicatable()
end

return GuiContainer