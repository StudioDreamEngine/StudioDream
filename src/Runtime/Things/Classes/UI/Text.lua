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

    self.RenderClass = Runtime.Renderer.ClassText() ---@class TextRender
end

function Text:DefineAPI()
    Text.super.DefineAPI(self)

    self.Proxy.Icon("Text")
    self.Proxy.MakeCreatable()
end

function Text:AttemptWrap(Size)
    --local Benchmark = Profiler.Benchmark("TextScaled Wrap")
    self.RenderClass.AttemptWrap(Size, self.TextScaled, self.TextSize)
    --Benchmark.End()
end

function Text:SetTextScaled(TextScaled)
    self.TextScaled = TextScaled
    self:InvalidateRendering()
end

function Text:SetText(Text)
    self.Text = Text
    self:InvalidateRendering()
end

function Text:ProcessInvalidation(Origin)
    Text.super.ProcessInvalidation(self, Origin)
    
    self:AttemptWrap(self.AbsoluteSize)
end

function Text:Draw()
    Text.super.Draw(self)

    self.RenderClass.Text = self.Text

    Runtime.Backend2D.SetColor(self.ForegroundColor,1-self.ForegroundTransparency)
    self.RenderClass.Render(self.AbsoluteSize, self.Alignment)
end

function Text:SetFont(NewFont)
    self.RenderClass:SetFont(NewFont)
    self:InvalidateRendering()
end

return Text