local Button = Runtime.Mixels.Extend("Mixel")

function Button:new(Thing)
    Thing.super.new(self)

    self.Hovering = false 
    self.HoverColorMultiplier = 0.75
    self.ClickingColorMultiplier = 0.5

    self.SinkHovering = true

    self.HoveringStyle = Enum.HoveringStyle.ColorMultiplier
    self.Transition = true

    self.Clicked = Signal:New("ButtonClicked")
    self.Released = Signal:New("ButtonReleased")

    self.ChangeCursorWhileHovering = true

    self.BeingClicked = false
    self.HoverEnter = Signal:New("ButtonHoverEnter")
    self.HoverExit  = Signal:New("ButtonHoverExit")
    self._WasHovering = false

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering then return end
        if (not self:IsActive()) then print("Inactive") return end
        self.BeingClicked = true
        self.Clicked.Invoke()
    end)

    Runtime.InterfaceManager.OnRelease:Connect(function()
        if not self.BeingClicked then return end
        
        self.BeingClicked = false
        self.Released.Invoke()
    end)
end

function Button:OnInitalParent(NewParent)
    self.Thing.super.OnInitalParent(self, NewParent)

    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function Button:OnRemove()
    self.Thing.super.OnRemove(self)

    self.Hovering = false
    self.Clicked:DisconnectAll()
    self.Released:DisconnectAll()
    self.HoverEnter:DisconnectAll()
    self.HoverExit:DisconnectAll()

    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function Button:Update(dt)
    self.Thing.super.Update(self)

    local DisplayUI = self.DisplayUI
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

return Button