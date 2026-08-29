local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Text: Square
local Text = Things.Extend("Square")

function Text:new()
    Text.super.new(self)

    self.TextSize = 12
    self.TextScaled = true
    self.Text = "Placeholder"
    self.AbsoluteText = "Placeholder"

    self.TextColorMultiplier = 1

    self.Font = nil
    
    self.RenderFont = nil

    self.Alignment = Vector2.zero

    self.FilterType = Enum.FilterType.Default

    --self.DefaultFont = Studio.CurrentTheme.FontNormal
end

function Text:OnReady()
    self.RenderClass = Runtime.Renderer.Text() ---@class TextRender
    self.RenderClass:new()
end

function Text:DefineAPI()
    Text.super.DefineAPI(self)

    self.Proxy.Icon("Text")
    self.Proxy.Property("string Text","Enum.Alignment Alignment","boolean TextScaled","number TextSize","Resource Font","Enum.FilterType FilterType")
    self.Proxy.Group("Text", "Text","Alignment","TextScaled","TextSize")
    self.Proxy.Group("Visual", "ForegroundColor", "ForegroundTransparency","FilterType","Font")
    self.Proxy.MakeCreatable()
end

function Text:AttemptWrap(Size)
    if (not self.TruelyVisible) then return end

    Profiler.Start("Text - Attempt Wrap")
    self.RenderClass:AttemptWrap(Size, self.TextScaled, self.TextSize)
    Profiler.End()
end

function Text:SetTextScaled(TextScaled)
    self.TextScaled = TextScaled

    self:InvalidateRendering()
end

function Text:SetAlignment(Alignment)
    self.Alignment = Alignment
    self.RenderClass:SetAlignment(Alignment)
    self:InvalidateRendering()
end

function Text:SetAbsoluteText(Text)
    self.AbsoluteText = Text
    self.RenderClass.Text = self.AbsoluteText

    self:InvalidateRendering()
end

function Text:SetText(Text)
    self.Text = Text or ""
    self:SetAbsoluteText(self.Text)
end

function Text:ProcessInvalidations()
    Text.super.ProcessInvalidations(self)
    self:AttemptWrap(self.AbsoluteSize)
end

function Text:Draw()
    Text.super.Draw(self)

    self:SetColor("Foreground", "TextColor")
    self.RenderClass:Render()
end

function Text:SetFilterType(NewFilter)
    self.FilterType = NewFilter
    self.RenderClass:SetFilter(NewFilter)
end

function Text:SetFont(Identifier)
    --print(Identifier)
    self.RenderFont, self.Font = Runtime.Resources.LoadResourceFromIdentifier(Identifier, self.UUID, {
        Property = "Font",
        Type = "Font"
    })
    if (not self.RenderFont) then return end

    self.RenderClass:SetFont(self.RenderFont)
    self:InvalidateRendering()
end

return Text