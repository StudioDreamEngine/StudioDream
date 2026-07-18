local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Text: Square
local Text = Things.Extend("Square")

function Text:new()
    Text.super.new(self)

    self.TextSize = 12
    self.TextScaled = true
    self.Text = "Placeholder"
    
    self.Alignment = Vector2.zero
    --self.DefaultFont = Studio.Theme.CurrentTheme.FontNormal
    self.RenderClass = Runtime.Renderer.ClassText() ---@class TextRender
end

function Text:DefineAPI()
    Text.super.DefineAPI(self)

    self.Proxy.Icon("Text")
    self.Proxy.Property("string Text","Enum.Alignment Alignment","boolean TextScaled","number TextSize")
    self.Proxy.Group("Text", "Text","Alignment","TextScaled","TextSize")
    self.Proxy.MakeCreatable()
end

function Text:AttemptWrap(Size)
    Profiler.Start("Text - Attempt Wrap")
    self.RenderClass.AttemptWrap(Size, self.TextScaled, self.TextSize)
    Profiler.End()
end

function Text:SetTextScaled(TextScaled)
    self.TextScaled = TextScaled

    self:AttemptWrap(self.AbsoluteSize)
    self:InvalidateRendering()
end

function Text:SetAlignment(Alignment)
    self.Alignment = Alignment
    self.RenderClass.SetAlignment(Alignment)
end

function Text:SetText(Text)
    self.Text = Text or ""
    self.RenderClass.Text = self.Text

    self:AttemptWrap(self.AbsoluteSize)
    self:InvalidateRendering()
end

function Text:SetAbsoluteSize(NewSize)
    Text.super.SetAbsoluteSize(self, NewSize)
    self:AttemptWrap(self.AbsoluteSize)
end

function Text:GetLetters()
    
end

function Text:Draw()
    Text.super.Draw(self)

    self:SetColor("Foreground")
    self.RenderClass.Render()
end

function Text:SetFont(NewFont)
    self.RenderClass.SetFont(NewFont)
    self:InvalidateRendering()
end

return Text