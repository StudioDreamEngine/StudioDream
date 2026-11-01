local Button = {}
Button.__index = Button

function Button.link(Thing)
    local self = setmetatable({},Button)
    self.Thing = Thing

    local LinkedThing = self.Thing 
    
    LinkedThing.Hovering = false 
    LinkedThing.HoverColorMultiplier = 0.75
    LinkedThing.ClickingColorMultiplier = 0.5

    LinkedThing.SinkHovering = true

    LinkedThing.HoveringStyle = Enum.HoveringStyle.ColorMultiplier
    LinkedThing.Transition = true

    LinkedThing.Clicked = Signal:New("ButtonClicked")
    LinkedThing.RightClicked = Signal:New("ButtonClickedRight")
    LinkedThing.Released = Signal:New("ButtonReleased")

    LinkedThing.ChangeCursorWhileHovering = true

    LinkedThing.BeingClicked = false
    LinkedThing.HoverEnter = Signal:New("ButtonHoverEnter")
    LinkedThing.HoverExit  = Signal:New("ButtonHoverExit")
    LinkedThing._WasHovering = false

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not LinkedThing.Hovering then return end
        if (not LinkedThing:IsActive()) then return end
        LinkedThing.BeingClicked = true
        LinkedThing.Clicked.Invoke()
    end)

    Runtime.InterfaceManager.OnRightClick:Connect(function()
        if not LinkedThing.Hovering then return end
        if (not LinkedThing:IsActive()) then return end

        LinkedThing.RightClicked.Invoke()
    end)

    Runtime.InterfaceManager.OnRelease:Connect(function()
        if not LinkedThing.BeingClicked then return end
        
        LinkedThing.BeingClicked = false
        LinkedThing.Released.Invoke()
    end)
    
    return self
end

function Button:OnInitalParent(NewParent)
    self.Thing.super.OnInitalParent(self.Thing, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.Thing.UUID)
end

function Button:OnRemove()
    local LinkedThing = self.Thing 
    
    LinkedThing.Hovering = false
    LinkedThing.Clicked:DisconnectAll()
    LinkedThing.Released:DisconnectAll()
    LinkedThing.HoverEnter:DisconnectAll()
    LinkedThing.HoverExit:DisconnectAll()

    Runtime.InterfaceManager.UnregisterButton(LinkedThing.UUID)
end

function Button:Update(dt)
    local TheLinkedThing = self.Thing

    local DisplayUI = TheLinkedThing.DisplayUI
    if (not DisplayUI) then return end
    
    if TheLinkedThing:IsActive() then
        local Delta = TheLinkedThing.Transition and math.min(dt*20,1) or 1

        if TheLinkedThing.HoveringStyle == "colorM" then
            local Clicking = TheLinkedThing.Hovering and Runtime.InterfaceManager.Clicking
            local Multiplier = (Clicking and TheLinkedThing.ClickingColorMultiplier) or (TheLinkedThing.Hovering and TheLinkedThing.HoverColorMultiplier) or 1
            TheLinkedThing.ColorMultiplier = math.lerp(TheLinkedThing.ColorMultiplier, Multiplier, Delta)
        elseif TheLinkedThing.HoveringStyle == "colorC" then
            
        end

        if ((not TheLinkedThing._WasHovering) and TheLinkedThing.Hovering) then TheLinkedThing.HoverEnter.Invoke() end
        if (TheLinkedThing._WasHovering and (not TheLinkedThing.Hovering)) then TheLinkedThing.HoverExit.Invoke() end

        TheLinkedThing._WasHovering = TheLinkedThing.Hovering
    end
end

return Button