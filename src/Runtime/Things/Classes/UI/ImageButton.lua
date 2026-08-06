local Things = Runtime.Things

---@class ImageButton: Image2D
local ImageButton = Things.Extend("Image2D")

function ImageButton:new()
    ImageButton.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "ImageButton"
    }

    self.Hovering = false 
    self.SinkHovering = true
    self.HoverColorMultiplier = 0.75
    self.ClickingColorMultiplier = 0.5

    self.Clicked = Signal:New("ButtonClicked")
    self.RightClicked = Signal:New("ButtonRightClicked") -- why isnt this in TextButton too???? x3
    self.HoverEnter = Signal:New("ButtonHoverEnter")
    self.HoverExit  = Signal:New("ButtonHoverExit")
    self._WasHovering = false

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering or not self:IsVisible() then return end
        self.Clicked.Invoke()
    end)

    Runtime.InterfaceManager.OnRightClick:Connect(function()
        if not self.Hovering or not self:IsVisible() then return end
        
        self.RightClicked.Invoke()
    end)

    -- "quote comment from TextButton here" :3
    self.HoverEnter:Connect(function()
        if Runtime.Cursor.CurrentCursor == 'HoldingObj' then return end
        Runtime.Cursor.ChangeCursor("Hovering")
    end)
    self.HoverExit:Connect(function()
        if Runtime.Cursor.CurrentCursor == 'HoldingObj' then return end
        Runtime.Cursor.ChangeCursor("Main")
    end)
end

function ImageButton:OnInitalParent(NewParent)
    ImageButton.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function ImageButton:OnRemove()
    self.Clicked:DisconnectAll()
    self.RightClicked:DisconnectAll()
    self.Hovering = false

    ImageButton.super.OnRemove(self)
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function ImageButton:DefineAPI()
    ImageButton.super.DefineAPI(self)

    self.Proxy.Icon("ImageButton")
    self.Proxy.MakeCreatable()
end

function ImageButton:Update(dt)
    ImageButton.super.Update(self)

    -- why is there TWO of them??? :!#$0o3$?AS"?#$%P!@)#(@)#$%(O :3
    local Clicking = self.Hovering and Runtime.InterfaceManager.Clicking

    local Clicking = self.Hovering and Runtime.InterfaceManager.Clicking
    local Multiplier = (Clicking and self.ClickingColorMultiplier) or (self.Hovering and self.HoverColorMultiplier) or 1
    self.ColorMultiplier = Multiplier

    if (not self._WasHovering and self.Hovering) then self.HoverEnter.Invoke() end
    if (self._WasHovering and not self.Hovering) then self.HoverExit.Invoke() end

    self._WasHovering = self.Hovering
end

return ImageButton