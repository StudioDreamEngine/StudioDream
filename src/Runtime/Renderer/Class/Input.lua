---@class InputRender: TextRender
local Input = Runtime.Renderer.Text:extend()

--[[
    My idea is that:
        The InputRender object handles the rendering and other general stuff for the text input,
        while TextInput handles the maintaining of the state and input events
]]

-- TODO: Make placeholder text a part of this class
function Input:new(TextInput)
    Input.super.new(self)

    self.Cursor = {
        Line = 1,
        PixelPosition = 0,
        CharPosition = 0
    }

    self.TextInput = TextInput ---@class TextInput

    self.BlinkTick, self.BlinkOn = 0, false
    self.BackHeld, self.BackTime, self.BackRepeat = nil, 0, 0

    self.Focused = false
end

function Input:GetPosition()
    return self.Cursor.CharPosition
end

-- Find a the nearest cursor point in the current line
function Input:CharacterAtPixelPos(PixelPosition, Line)
    for CharacterIndex = 1, #Line do
        local Character = string.sub(Line, 0, CharacterIndex)
        local Width = self:GetWidth(Character)

        if PixelPosition <= Width then
            return CharacterIndex, Width
        end
    end
end

function Input:CharacterAtRenderPos(Position)
    local CurrentLine, Line = 0, ""
    local CurrentPosition = 0

    for LineIndex, LineString in pairs(self.Lines.Lines) do
        local LineY = (LineIndex-1)*self.Lines.Height

        if LineY+self.Lines.Height > Position.Y then
            CurrentLine, Line = LineIndex, LineString
            self.Cursor.Line = CurrentLine
            self.Cursor.PixelPosition = self:GetWidth(LineString)

            break
        end

        CurrentPosition = CurrentPosition + #LineString
    end

    local Length, PixelPosition = self:CharacterAtPixelPos(Position.X, Line)

    if Length then
        CurrentPosition = CurrentPosition + Length
        self.Cursor.PixelPosition = PixelPosition
    end

    self.Cursor.CharPosition = CurrentPosition
    self:RefreshBlinkCursor(true)
end

-- Returns the new text and cursor position depending on the character
function Input:GetNew(Character)
    local CurrentPos = self:GetPosition()

    local PostText = string.sub(self.Text, CurrentPos+1, -1)

    if string.byte(Character) == 0x08 then
        if CurrentPos < 1 then CurrentPos = 1 end

        return string.sub(self.Text, 0, CurrentPos-1)..PostText, CurrentPos - 1
    else
        return string.sub(self.Text, 0, CurrentPos)..Character..PostText, CurrentPos + 1
    end
end

function Input:ChangePositionBy(By)
    self:ChangePosition(self.Cursor.CharPosition + By)
end

function Input:ChangePosition(To)
    self.Cursor.QueuedPosition = To
end

function Input:ToggleFocus(Focus, MousePosition)
    self.Focused = Focus

    if Focus then
        local Offset = MousePosition * self.Lines.Scale - self.OffsetPosition
        self:ChangePosition(self:CharacterAtRenderPos(Offset))
    end
end

function Input:SetBackspace(Backspace)
    self.BackHeld = Backspace

    if Backspace then
        self.BackTime = GlobalTick
        self:HandleKey(string.char(8))
    end
end

function Input:HandleKey(Key)
    local Text, Pos = self:GetNew(Key)

    self.TextInput:SetText(Text)
    self:ChangePosition(Pos)
end

function Input:HandleHold()
    if (not self.BackHeld) or (GlobalTick - self.BackTime < 0.5) then return end

    if (GlobalTick - self.BackRepeat) > 0.04 then
        self.BackRepeat = GlobalTick

        self:HandleKey(string.char(8))
    end
end

-- Get the current line based off a position in the text
function Input:GetLineFromPosition(Position)
    if (Position == 0) then return 1, "" end -- dumb hack

    local Total = 0
    local Line, Character = 0, ""

    local GotLine = false

    -- idk if this is optimized
    for LineI, SingleLine in pairs(self.Lines.Lines) do
        for CharacterI = 1, #SingleLine do
            Total = Total + 1
            
            if Total >= Position then
                Line = LineI
                Character = string.sub(SingleLine, 0, CharacterI)
                GotLine = true

                break
            end
        end

        if GotLine then break end
    end

    return Line, Character
end

function Input:UpdateCursor()
    if (not self.Focused) then return end

    local CursorBench = Profiler.Benchmark("Update Cursor")

    self.Cursor.CharPosition = math.clamp(self.Cursor.CharPosition, 0, #self.ContentText)

    local Line, Character = self:GetLineFromPosition(self.Cursor.CharPosition)

    self.Cursor.Line = Line
    self.Cursor.PixelPosition = self:GetWidth(Character)

    CursorBench.End()
end

function Input:GetWidth(Text, Sub)
    return self.RenderFont:getWidth(Sub and string.sub(Text, 1, Sub) or Text)
end

function Input:RefreshBlinkCursor(Toggle)
    self.BlinkTick = GlobalTick
    self.BlinkOn = Toggle
end

function Input:Render()
    if self.Cursor.QueuedPosition then
        self.Cursor.CharPosition = self.Cursor.QueuedPosition
        self.Cursor.QueuedPosition = nil

        self:UpdateCursor()
        self:RefreshBlinkCursor(true)
    end

    Input.super.Render(self)

    if (GlobalTick - self.BlinkTick) > 0.5 then
        self:RefreshBlinkCursor(not self.BlinkOn)
    end
end

function Input:RenderLine(Index, Line)
    Input.super.RenderLine(self, Index, Line)

    if (Index+1 == self.Cursor.Line) and self.Focused and self.BlinkOn then
        love.graphics.pushAll()

        local r,g,b = love.graphics.getColor()
        love.graphics.setColor(r,g,b,0.5)

        love.graphics.rectangle("fill", self.Cursor.PixelPosition, 0, 2, self.Lines.Height)

        love.graphics.pop()
    end
end

return Input