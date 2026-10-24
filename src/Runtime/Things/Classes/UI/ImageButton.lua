local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class ImageButton: ImageButton
local ImageButton = Things.Extend("Image2D")

function ImageButton:new()
    ImageButton.super.new(self)

    self.Mixin = Runtime.Mixins.Create(self,"Button")
end

function ImageButton:Update(dt)
    ImageButton.super.Update(self)

    self.Mixin:Update(dt)
end

function ImageButton:OnRemove()
    ImageButton.super.OnRemove(self)

    self.Mixin:OnRemove()
end

function ImageButton:OnInitalParent(NewParent)
    ImageButton.super.OnInitalParent(self, NewParent)

    self.Mixin:OnInitalParent(NewParent)
end

function ImageButton:DefineAPI()
    ImageButton.super.DefineAPI(self)

    self.Proxy.Icon("ImageButton")
    self.Proxy.Property("boolean ChangeCursorWhileHovering","boolean Hovering","number HoverColorMultiplier","number ClickingColorMultiplier","boolean SinkHovering","boolean Active")
    self.Proxy.Group("Hovering","ChangeCursorWhileHovering","Hovering","HoverColorMultiplier","ClickingColorMultiplier","SinkHovering","Active")
    self.Proxy.MakeCreatable()
end

return ImageButton