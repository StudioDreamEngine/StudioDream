local function GetFont(Name, Weight)
    Name = Name or "Roboto"
    Weight = Weight or "Medium"

    return string.format("Assets/Fonts/%s/%s-%s.ttf", Name, Name, Weight)
end

---@class TextRender: ClassicObject
local Text = Object:extend()

function Text:new()
    self.RenderFont = nil
    self.ContainerSize  = Vector2.zero

    self.Alignment = Enum.Alignment.MiddleLeft

    self.OffsetPosition = Vector2.zero

    self.Text = "Placeholder"
    self.Lines = {
        Width = 0,
        Lines = {},
        Height = 0
    } 

    self:SetFont("Roboto")
end

function Text:SetAlignment(NewAlignment)
    if NewAlignment then
        self.Alignment = NewAlignment
    end

    -- not the greatest, but cut on variables
    self.OffsetPosition = Utils.GetAlignment(self.Alignment, self.ContainerSize, Vector2.new(self.Lines.Width, (#self.Lines.Lines * self.Lines.Height)))
end

-- Rendering
function Text:SetFont(Font)
    if type(Font) == "string" then
        local Font = Font and string.split(Font, "-") or {}
        self.RenderFont = love.graphics.newFont(GetFont(Font[1], Font[2]),32)
    else
        self.RenderFont = Font
    end
end

function Text:SetFilter(NewFilter)
    self.RenderFont:setFilter(NewFilter,NewFilter)
end

-- Wrapping
function Text:PerformWrap(CurrentSize, WrapLength)
    local Scale = 32 / CurrentSize

    local Width, Lines = self.RenderFont:getWrap(self.Text, WrapLength * Scale)
    local Height = self.RenderFont:getHeight()/Scale

    Width = Width/Scale

    -- should simplify this y axis equation tbh
    return Vector2.new(Width, (#Lines * Height)), {
        Width = Width,
        Scale = Scale,
        Height = Height,
        Lines = Lines
    }
end

function Text:SearchScaled(ContainerSize)
    local CurrentSize = ContainerSize.Y+1
    local Min, Max = 1, ContainerSize.Y

    local TextBounds, Lines

    Profiler.Start("Text - Perform Scaled Wrap")
    if self.Text == "" or ContainerSize.Y < 1 then -- Default to size 1
        Profiler.End()
        return self:PerformWrap(1, ContainerSize.X)
    end

    local Loops = 0

    -- Perform a very overcomplicated binary search to find the best fit
    while true do
        CurrentSize = Min + (Max - Min)/2
        TextBounds, Lines = self:PerformWrap(CurrentSize, ContainerSize.X)
        Loops = Loops + 1

        local Y = TextBounds.Y

        if math.abs(ContainerSize.Y - Y) < ContainerSize.Y/4 then
            break
        end

        if Loops > 5 then
            --printVerbose("Failed to fit text: \""..Text.Text.."\" after 8 fitting attempts")
            break
        end

        if ContainerSize.Y < Y then -- Text is too big
            Max = CurrentSize -- We now know this is our upper limit
        elseif ContainerSize.Y > Y then -- Text is too small
            Min = CurrentSize -- We now know this is our lower limit
        end
    end
    Profiler.End()

    return TextBounds, Lines
end

function Text:AttemptWrap(NewSize, TextScaled, TextSize)
    local ContainerSize = NewSize
    local Lines

    if TextScaled then
        _, Lines = self:SearchScaled(ContainerSize)
    else
        _, Lines = self:PerformWrap(TextSize, ContainerSize.X)
    end

    Lines.Height = Lines.Height * Lines.Scale
    Lines.Width = Lines.Width  * Lines.Scale

    self.Lines = Lines
    self.ContainerSize = NewSize*Lines.Scale

    self:SetAlignment()
end

function Text:RenderLine(Index, Line)
    love.graphics.print(Line,0,0) 
end

function Text:Render()
    love.graphics.setFont(self.RenderFont)
    love.graphics.push()
    love.graphics.scale(1/self.Lines.Scale)

    for LineIndex, Line in pairs(self.Lines.Lines) do
        love.graphics.push()
        love.graphics.translate(self.OffsetPosition.X, self.OffsetPosition.Y+((LineIndex-1)*self.Lines.Height))
        self:RenderLine(LineIndex-1, Line)
        love.graphics.pop()
    end

    love.graphics.pop()
end

return Text