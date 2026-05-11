return function()
    ---@class TextRender
    local Text = {}

    Text.RenderFont = nil
    Text.TextBounds = Vector2.zero

    Text.Scale = 0

    Text.Text = "Placeholder"

    local function PerformWrap(CurrentSize, WrapLength)
        local Scale = 32 / CurrentSize

        local width, lines = Text.RenderFont:getWrap(Text.Text, WrapLength * Scale)

        -- should simplify this y axis equation tbh
        return Vector2.new(width/Scale, (#lines * Text.RenderFont:getHeight())/Scale), Scale
    end

    function Text.PassProperties(Properties)
        for i, p in pairs(Properties) do Text[i] = p end
    end

    function Text.SetFont(Font)
        Text.RenderFont = love.graphics.newFont(Font or "Assets/Fonts/Roboto/Roboto-Medium.ttf",32)
    end

    Text.SetFont()

    function Text.AttemptWrap(NewSize, TextScaled, TextSize)
        local ContainerSize = NewSize
        local TextBounds, Scale

        if TextScaled then
            local CurrentSize = math.max(ContainerSize.Y,1)
            local InvalidationCount = 0

            repeat
                TextBounds, Scale = PerformWrap(CurrentSize, ContainerSize.X)

                CurrentSize = CurrentSize - 1
                InvalidationCount = InvalidationCount + 1
            until ContainerSize.Y > TextBounds.Y or CurrentSize <= 1
        else
            TextBounds, Scale = PerformWrap(TextSize, ContainerSize.X)
        end

        Text.TextBounds = TextBounds
        Text.Scale = Scale
    end

    function Text.Render(LoveAlign, ContainerSize)
        local TextPosition = Vector2.new(0,ContainerSize.Y/2 - Text.TextBounds.Y/2)

        love.graphics.setFont(Text.RenderFont)
        love.graphics.push()
        love.graphics.scale(1/Text.Scale)
        love.graphics.printf(Text.Text, TextPosition.X, TextPosition.Y, Text.TextBounds.X*Text.Scale, LoveAlign)
        love.graphics.pop()
    end

    return Text
end