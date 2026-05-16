local Things = Runtime.Things

-- We should maybe merge this and ImageButton, for now however this will be how it works
-- using @module here gives the lua language server a base type to use!
---@class TextButton: Text
local TextButton = Things.Extend("Image2D")

function TextButton:new()
    TextButton.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "TextButton"
    }

    self.Hovering = false 
    self.Clicked = Signal:New("ButtonClicked")
    
    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering then return end
        
        self.Clicked.Invoke()
    end)
end

function TextButton:Update(dt)
    TextButton.super.Update(self)

    local DisplayUI = self:GetDisplayUI()
    if (not DisplayUI) then return end

    local ObjectRect = self:GetRect()

    self.Hovering = Utils.IntersectPoint2D(ObjectRect, DisplayUI.MousePosition)

    local Clicking = self.Hovering and Runtime.InterfaceManager.Clicking

    local Multiplier = (Clicking and 0.5) or (self.Hovering and 0.75) or 1
    self.ColorMultiplier = Multiplier
end

return TextButton