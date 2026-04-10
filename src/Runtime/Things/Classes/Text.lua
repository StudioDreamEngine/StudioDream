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
end

function Text:PerformWrap(CurrentSize, WrapLength)
    self.RenderFont = love.graphics.newFont("Assets/Fonts/Arimo.ttf",CurrentSize)

    local width, lines = self.RenderFont:getWrap(self.Text, WrapLength)

    -- should simplify this y axis equation tbh
    return Vector2.new(width, #lines * self.RenderFont:getHeight())
end

function Text:SetAbsoluteSize(New)
    Text.super.SetAbsoluteSize(self, New)

    local TextBounds, RenderFont = self:AttemptWrap(New)

    self.TextBounds = TextBounds
    self.RenderFont = RenderFont
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

    return TextSize, self.RenderFont
end

function Text:Draw()
    Text.super.Draw(self)

    --[[local YAlign = 0

    if self.AlignY == Enum.AlignmentY.Bottom then
        YAlign = self.TextBounds.Y
    elseif self.AlignY == Enum.AlignmentY.Center then
        YAlign = self.TextBounds.Y/2
    end]]

    love.graphics.setFont(self.RenderFont)

    Runtime.Backend2D.SetColor(Color.new(1,0,0))
    love.graphics.rectangle("line", 0,0,self.TextBounds.X,self.TextBounds.Y)
    Runtime.Backend2D.SetColor(self.ForegroundColor)
    love.graphics.printf(self.Text, 0, 0, self.TextBounds.X, self.AlignX)
end

return Text