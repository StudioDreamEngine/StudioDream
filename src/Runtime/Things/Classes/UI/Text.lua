local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Text: Square
local Text = Things.Extend("Square")

function Text:new()
    Text.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "Text"
    }

    self.TextSize = 12
    self.TextScaled = true

    self.Text = "Placeholder"

    self.AlignX = Enum.AlignmentX.Center
    self.AlignY = Enum.AlignmentY.Center

    self.RenderClass = Runtime.Renderer.ClassText() ---@class TextRender
end

function Text:AttemptWrap(Size)
    self.RenderClass.PassProperties({
        Text = self.Text,
        Font = self.Font
    })

    self.RenderClass.AttemptWrap(Size, self.TextScaled, self.TextSize)
end

function Text:SetText(Text)
    self.Text = Text
    self:InvalidateRendering()
end

function Text:ProcessInvalidation()
    Text.super.ProcessInvalidation(self)
    
    self:AttemptWrap(self.AbsoluteSize)
end

function Text:Draw()
    Text.super.Draw(self)

    Runtime.Backend2D.SetColor(self.ForegroundColor)
    self.RenderClass.Render(self.AlignX, self.AbsoluteSize)
end

return Text