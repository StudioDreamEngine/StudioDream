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

return GuiContainer