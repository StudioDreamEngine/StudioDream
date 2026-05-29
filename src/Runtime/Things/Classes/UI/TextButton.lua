local Things = Runtime.Things

-- We should maybe merge this and ImageButton, for now however this will be how it works
-- using @module here gives the lua language server a base type to use!
---@class TextButton: Text
local TextButton = Things.Extend("Text")

function TextButton:new()
    TextButton.super.new(self)

    self.Hovering = false 
    self.HoverColorMultiplier = 0.75
    self.ClickingColorMultiplier = 0.5
    --self.LastHover = false
    
    -- not implemented yet
    self.SinkHovering = false -- If true, blocks hovering from being true on objects lower than its layer

    self.Clicked = Signal:New("ButtonClicked")
    
    self.ChangeCursorWhileHovering = true

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering or not self:IsVisible() then return end
        
        self.Clicked.Invoke()
    end)
end

function TextButton:DefineAPI()
    TextButton.super.DefineAPI(self)

    self.Proxy.Icon("TextButton")
    self.Proxy.Property("boolean ChangeCursorWhileHovering","boolean Hovering")
    self.Proxy.MakeCreatable()
end

function TextButton:Update(dt)
    TextButton.super.Update(self)

    local DisplayUI = self:GetDisplayUI()
    if (not DisplayUI) then return end

    local ObjectRect = self:GetRect()

    self.Hovering = Utils.IntersectPoint2D(ObjectRect, DisplayUI.MousePosition)

    local Clicking = self.Hovering and Runtime.InterfaceManager.Clicking
    local Multiplier = (Clicking and self.ClickingColorMultiplier) or (self.Hovering and self.HoverColorMultiplier) or 1
    self.ColorMultiplier = Multiplier
end

return TextButton