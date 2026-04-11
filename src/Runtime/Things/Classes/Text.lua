local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@module 'SquarePrimative'
local Text = Things.Extend("SquarePrimative")

function Text:new()
    Text.super.new(self)

    self.Explorer = {
        Visible = true,
        Icon = "text_replace"
    }

    self.TextSize = 12
    self.TextScaled = true

    self.Text = "Placeholder"

    self.AlignX = Enum.AlignmentX.Center
    self.AlignY = Enum.AlignmentY.Center

    self.RenderFont = nil
    self.TextBounds = Vector2.zero

    self:AttemptWrap(self.AbsoluteSize)
end

function Text:PerformWrap(CurrentSize, WrapLength)
    self.RenderFont = love.graphics.newFont("Assets/Fonts/Arimo.ttf",CurrentSize)

    local width, lines = self.RenderFont:getWrap(self.Text, WrapLength)

    -- should simplify this y axis equation tbh
    return Vector2.new(width, #lines * self.RenderFont:getHeight())
end

function Text:SetAbsoluteSize(New)
    Text.super.SetAbsoluteSize(self, New)

    self:AttemptWrap(New)
end

function Text:AttemptWrap(NewSize)
    local ContainerSize = NewSize

    local TextSize

    if self.TextScaled then
        local CurrentSize = math.max(ContainerSize.Y,1)

        repeat
            TextSize = self:PerformWrap(CurrentSize, ContainerSize.X)

            CurrentSize = CurrentSize - 1
        until ContainerSize.Y > TextSize.Y or CurrentSize <= 1
    else
        TextSize = self:PerformWrap(self.TextSize, ContainerSize.X)
    end

    self.TextBounds = TextSize

    return TextSize, self.RenderFont
end

function Text:Draw()
    Text.super.Draw(self)

    local CurrentSize = self.AbsoluteSize

    local Divisor = 2

    --[[if self.AlignY == Enum.AlignmentY.Bottom then
        Divisor = 1
    elseif self.AlignY == Enum.AlignmentY.Center then
        Divisor = 2
    end]]

    local TextPosition = Vector2.new(0,CurrentSize.Y/Divisor - self.TextBounds.Y/Divisor)
    
    love.graphics.setFont(self.RenderFont)
    Runtime.Backend2D.SetColor(Color.new(1,0,0))

    love.graphics.rectangle("line", TextPosition.X, TextPosition.Y, self.TextBounds.X, self.TextBounds.Y)
    Runtime.Backend2D.SetColor(self.ForegroundColor)
    love.graphics.printf(self.Text, TextPosition.X, TextPosition.Y, self.TextBounds.X, self.AlignX)
end

return Text