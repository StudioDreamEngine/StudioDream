local Things = Runtime.Things

-- We should maybe merge this and ImageButton, for now however this will be how it works
-- using @module here gives the lua language server a base type to use!
---@module 'Text'
local TextButton = Things.Extend("Text")

function TextButton:new()
    TextButton.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "textfield_rename"
    }

    self.Hovering = false 
    self.Clicked = Signal:New("ButtonClicked")

    Runtime.InterfaceManager.OnClick:Connect(self.Clicked.Invoke)
end

function TextButton:Update(dt)
    TextButton.super.Update(self)

    local DisplayUI = self:GetDisplayUI()
    if (not DisplayUI) then return end

    local ObjectRect = self:GetRect()

    local Hovering = Utils.IntersectPoint2D(ObjectRect, DisplayUI.MousePosition)
    local Clicking = Hovering and Runtime.InterfaceManager.Clicking

    local Multiplier = (Clicking and 0.5) or (Hovering and 0.75) or 1
    self.ColorMultiplier = Multiplier
end

return TextButton