local Things = Runtime.Things

---@class GuiContainer: ViewportContainer
local GuiContainer = Things.Extend("ViewportContainer")

function GuiContainer:new()
    GuiContainer.super.new(self)

    self.MousePosition = Vector2.zero
end

function GuiContainer:ProcessInvalidation(Origin)
    for _, v in pairs(self:GetInterfaceChildren()) do
        v:ProcessInvalidation(Origin)
    end
end

function GuiContainer:DefineAPI()
    GuiContainer.super.DefineAPI(self)

    self.Proxy.Creatable = false
    self.Proxy.MakeNonDuplicatable()
end

return GuiContainer