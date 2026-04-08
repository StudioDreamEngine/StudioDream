local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Text = Things.Extend("SquarePrimative")

function Text:new()
    Text.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "text_replace"
    }

    self.TextSize = 12
    self.Text = "Placeholder"
    self.AlignX = Enum.AlignmentX.Center
    self.AlignY = Enum.AlignmentY.Center
    self.FontFile = nil
end

function Text:Draw() -- Make size being rendered when window changes size again
    Text.super.Draw(self)

    local ContainerSize = self.AbsoluteSize

    self.RenderFont = love.graphics.newFont(self.FontFile or "Assets/Fonts/Arimo.ttf",self.TextSize)

    local width, lines = self.RenderFont:getWrap(self.Text, ContainerSize.X)

    -- should simplify this y axis equation tbh
    local TextSize = Vector2.new(width, #lines * self.RenderFont:getHeight() - #lines * self.RenderFont:getLineHeight()*2)

    local YAlign = 0
    if self.AlignY == Enum.AlignmentY.Bottom then
        YAlign = TextSize.Y
    elseif self.AlignY == Enum.AlignmentY.Center then
        YAlign = TextSize.Y/2
    elseif self.AlingY == Enum.AlignmentY.Top then
        YAlign = -TextSize.Y --???
    end

    Runtime.Backend2D.SetColor(self.ForegroundColor)
    love.graphics.printf(self.Text, 0, YAlign, ContainerSize.X, self.AlignX)
end

return Text