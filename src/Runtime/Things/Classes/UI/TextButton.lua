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

    self.SinkHovering = true

    self.HoveringStyle = Enum.HoveringStyle.ColorMultiplier
    self.Transition = true -- if to transition the hovering effect
        --self.LastHover = false
    
    -- not implemented yet
    --self.SinkHovering = false -- If true, blocks hovering from being true on objects lower than its layer

    self.Clicked = Signal:New("ButtonClicked")
    self.Released = Signal:New("ButtonReleased")

    self.ChangeCursorWhileHovering = true
    self.HoverEnter = Signal:New("ButtonHoverEnter")
    self.HoverExit  = Signal:New("ButtonHoverExit")
    self._WasHovering = false

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering then return end
        if (not self:IsActive()) then return end

        self.Clicked.Invoke()
    end)

    Runtime.InterfaceManager.OnRelease:Connect(function()
        if not self.Hovering then return end
        
        self.Released.Invoke()
    end)
end

function TextButton:OnInitalParent(NewParent)
    TextButton.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function TextButton:OnRemove()
    TextButton.super.OnRemove(self)

    self.Hovering = false
    self.Clicked:DisconnectAll()
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function TextButton:DefineAPI()
    TextButton.super.DefineAPI(self)

    self.Proxy.Icon("TextButton")
    self.Proxy.Property("boolean ChangeCursorWhileHovering","boolean Hovering","number HoverColorMultiplier","number ClickingColorMultiplier","boolean SinkHovering","boolean Active")
    self.Proxy.Group("Hovering","ChangeCursorWhileHovering","Hovering","HoverColorMultiplier","ClickingColorMultiplier","SinkHovering","Active")
    self.Proxy.MakeCreatable()
end

function TextButton:Update(dt)
    TextButton.super.Update(self)

    local DisplayUI = self:GetDisplayUI()
    if (not DisplayUI) then return end

    local Delta = self.Transition and math.min(dt*20,1) or 1
    
    if self.HoveringStyle == "colorM" then
        local Clicking = self.Hovering and Runtime.InterfaceManager.Clicking
        local Multiplier = (Clicking and self.ClickingColorMultiplier) or (self.Hovering and self.HoverColorMultiplier) or 1

        self.ColorMultiplier = math.lerp(self.ColorMultiplier, Multiplier, Delta)
    elseif self.HoveringStyle == "colorC" then
        --local ColorToChange = 
    end

    if ((not self._WasHovering) and self.Hovering) then self.HoverEnter.Invoke() end
    if (self._WasHovering and (not self.Hovering)) then self.HoverExit.Invoke() end

    self._WasHovering = self.Hovering
end

return TextButton