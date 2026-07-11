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

    self.Clicked = Signal:New("ButtonClicked")
    self.RightClicked = Signal:New("ButtonRightClicked")

    Runtime.InterfaceManager.OnClick:Connect(function()
        if not self.Hovering or not self:IsVisible() then return end
        self.Clicked.Invoke()
    end)

    Runtime.InterfaceManager.OnRightClick:Connect(function()
        if not self.Hovering or not self:IsVisible() then return end
        
        self.RightClicked.Invoke()
    end)
end

function ImageButton:OnInitalParent(NewParent)
    ImageButton.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function ImageButton:OnRemove()
    self.Clicked:DisconnectAll()
    self.RightClicked:DisconnectAll()

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

    local Clicking = self.Hovering and Runtime.InterfaceManager.Clicking

    local Multiplier = (Clicking and 0.5) or (self.Hovering and 0.75) or 1
    self.ColorMultiplier = Multiplier
end

return ImageButton