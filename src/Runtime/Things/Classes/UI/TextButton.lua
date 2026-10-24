local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class TextButton: TextButton
local TextButton = Things.Extend("Text")

function TextButton:new()
    TextButton.super.new(self)

    self.Mixin = Runtime.Mixins.Create(self,"Button")
end

function TextButton:Update(dt)
    TextButton.super.Update(self)

    self.Mixin:Update(dt)
end

function TextButton:OnRemove()
    TextButton.super.OnRemove(self)

    self.Mixin:OnRemove()
end

function TextButton:OnInitalParent(NewParent)
    TextButton.super.OnInitalParent(self, NewParent)

    self.Mixin:OnInitalParent(NewParent)
end

function TextButton:DefineAPI()
    TextButton.super.DefineAPI(self)

    self.Proxy.Icon("TextButton")
    self.Proxy.Property("boolean ChangeCursorWhileHovering","boolean Hovering","number HoverColorMultiplier","number ClickingColorMultiplier","boolean SinkHovering","boolean Active")
    self.Proxy.Group("Hovering","ChangeCursorWhileHovering","Hovering","HoverColorMultiplier","ClickingColorMultiplier","SinkHovering","Active")
    self.Proxy.MakeCreatable()
end

return TextButton