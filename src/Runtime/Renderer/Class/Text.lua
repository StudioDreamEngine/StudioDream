return function()
    ---@class TextRender
    local Text = {}

    Text.RenderFont = nil
    Text.TextBounds = Vector2.zero

    Text.Text = "Placeholder"
    Text.Font = nil

    local function PerformWrap(CurrentSize, WrapLength)
        Text.RenderFont = love.graphics.newFont(Text.Font or "Assets/Fonts/Roboto/Roboto-Medium.ttf",CurrentSize)

        local width, lines = Text.RenderFont:getWrap(Text.Text, WrapLength)

        -- should simplify this y axis equation tbh
        return Vector2.new(width, #lines * Text.RenderFont:getHeight())
    end

    function Text.PassProperties(Properties)
        for i, p in pairs(Properties) do Text[i] = p end
    end

    function Text.AttemptWrap(NewSize, TextScaled, TextSize)
        local ContainerSize = NewSize
        local TextBounds

        if TextScaled then
            local CurrentSize = math.max(ContainerSize.Y,1)
            local InvalidationCount = 0

            repeat
                TextBounds = PerformWrap(CurrentSize, ContainerSize.X)

                CurrentSize = CurrentSize - 1
                InvalidationCount = InvalidationCount + 1
            until ContainerSize.Y > TextBounds.Y or CurrentSize <= 1

            --printVerbose("Invalidated TextSize "..InvalidationCount.." Times")
        else
            TextBounds = PerformWrap(TextSize, ContainerSize.X)
        end

        Text.TextBounds = TextBounds
    end

    function Text.Render(LoveAlign, ContainerSize)
        local TextPosition = Vector2.new(0,ContainerSize.Y/2 - Text.TextBounds.Y/2)

        love.graphics.setFont(Text.RenderFont)
        love.graphics.printf(Text.Text, TextPosition.X, TextPosition.Y, Text.TextBounds.X, LoveAlign)
    end

    return Text
end