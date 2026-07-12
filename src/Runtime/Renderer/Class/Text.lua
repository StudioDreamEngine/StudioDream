local function GetFont(Name, Weight)
    Name = Name or "Roboto"
    Weight = Weight or "Medium"

    return string.format("Assets/Fonts/%s/%s-%s.ttf", Name, Name, Weight)
end

return function()
    ---@class TextRender
    local Text = {}

    Text.RenderFont = nil
    Text.TextBounds = Vector2.zero

    Text.Scale = 0

    Text.Text = "Placeholder"

    Text.Lines = {}

    -- Wrapping
    local function PerformWrap(CurrentSize, WrapLength)
        local Scale = 32 / CurrentSize
        local Width, Lines = Text.RenderFont:getWrap(Text.Text, WrapLength * Scale)
        local Height = Text.RenderFont:getHeight()/Scale

        Width = Width/Scale

        -- should simplify this y axis equation tbh
        return Vector2.new(Width, (#Lines * Height)), {
            Width = Width,
            Scale = Scale,
            Height = Height,
            Lines = Lines
        }
    end

    -- TODO: Perform a binary search from 1 to ContainerSize.Y, as opposed to a linear search 
    local function SearchScaled(ContainerSize)
        local MaxSize, MinSize = ContainerSize.Y, 1
        local CurrentSize = MaxSize

        local TextBounds, Lines

        repeat
            TextBounds, Lines = PerformWrap(CurrentSize, ContainerSize.X)

            CurrentSize = CurrentSize - 1
        until ContainerSize.Y > TextBounds.Y or CurrentSize <= 1

        return TextBounds, Lines
    end

    function Text.AttemptWrap(NewSize, TextScaled, TextSize)
        local ContainerSize = NewSize
        local TextBounds, Lines

        if TextScaled then
            TextBounds, Lines = SearchScaled(ContainerSize)
        else
            TextBounds, Lines = PerformWrap(TextSize, ContainerSize.X)
        end

        Text.Lines = Lines
        Text.TextBounds = TextBounds
        Text.Scale = Lines.Scale
    end

    -- Rendering
    function Text.SetFont(Font)
        local Font = Font and string.split(Font, "-") or {}
        Text.RenderFont = love.graphics.newFont(GetFont(Font[1], Font[2]),32)
    end

    Text.SetFont()

    -- Get the position (Vector2) of where a location in the text is
    function Text.GetPositionFromLocation(Location)
        
    end

    -- Get the location in text from where a position is
    function Text.GetLocationFromPosition(Location)
        
    end

    function Text.Render(ContainerSize, Alignment)
        local TextPosition = Utils.GetAlignment(Alignment, ContainerSize, Text.TextBounds)*Text.Scale

        love.graphics.setFont(Text.RenderFont)
        love.graphics.push()
        love.graphics.scale(1/Text.Scale)
        love.graphics.printf(Text.Text, TextPosition.X, TextPosition.Y, Text.Lines.Width*Text.Scale)
        love.graphics.pop()
    end

    return Text
end