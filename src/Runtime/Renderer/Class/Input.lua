---@class InputRender: TextRender
local Input = Runtime.Renderer.Text:extend()

function Input:new()
    Input.super.new(self)

    self.Cursor = {
        Line = 1,
        PixelPosition = 0,
        CharPosition = 0
    }

    self.BlinkTick, self.BlinkOn = 0, false

    self.Focused = false
end

function Input:ChangePosBy(By)
    self:ChangePos(self.Cursor.CharPosition + By)
end

function Input:ChangePos(To)
    self.Cursor.CharPosition = To
    self:UpdateCursor()
end

function Input:ToggleFocus(Focus)
    self.Focused = Focus

    if Focus then
        self:ChangePos(#self.Text)
    end
end

function Input:AttemptWrap(...)
    Input.super.AttemptWrap(self, ...)
end

function Input:OnClick()
    
end

-- Get the current line based off a position in the text
function Input:GetLineFromPosition(Position)
    if (Position == 0) then return 1, "" end -- dumb hack

    local Total = 0
    local Line, Character = 0, ""

    -- idk if this is optimized
    for LineI, SingleLine in pairs(self.Lines.Lines) do
        for CharacterI, _ in pairs(string.split(SingleLine, ".")) do
            Total = Total + 1

            if Total >= Position then
                Line = LineI
                Character = string.sub(SingleLine, 1, CharacterI)
                break
            end
        end
    end

    return Line, Character
end

function Input:UpdateCursor()
    if (not self.Focused) then return end
    
    local CursorBench = Profiler.Benchmark("Update Cursor")

    self.Cursor.CharPosition = math.clamp(self.Cursor.CharPosition, 0, #self.Text)

    local Line, Character = self:GetLineFromPosition(self.Cursor.CharPosition)

    self.Cursor.Line = Line
    self.Cursor.PixelPosition = self:GetWidth(Character)

    CursorBench.End()
end

function Input:GetWidth(Text, Sub)
    return self.RenderFont:getWidth(Sub and string.sub(Text, 1, Sub) or Text)
end

function Input:Render()
    Input.super.Render(self)

    if (GlobalTick - self.BlinkTick) > 0.5 then
        self.BlinkTick = GlobalTick
        self.BlinkOn = not self.BlinkOn
    end
end

function Input:RenderLine(Index, Line)
    Input.super.RenderLine(self, Index, Line)

    local r,g,b = love.graphics.getColor()
    love.graphics.setColor(r,g,b,0.5)

    if (Index+1 == self.Cursor.Line) and self.Focused and self.BlinkOn then
        love.graphics.rectangle("fill", self.Cursor.PixelPosition, 0, 2, self.Lines.Height)
    end
end

return Input