local Pivot2D = {}

function Pivot2D.new(ScaleX, OffsetX, ScaleY, OffsetY)
    --printVerbose("Cooll!!!")
    --printVerbose(ScaleX, OffsetX, ScaleY, OffsetY)
    local Offset = Vector2.new(OffsetX, OffsetY)
    local Scale = Vector2.new(ScaleX, ScaleY) -- TODO: Rename to Pivot instead of scale
    
    return Pivot2D.FromAxises(Scale, Offset)
end

---@class Pivot2D
local Methods = {
    Type = "Pivot2D",
    Offset = nil, ---@class Vector2
    Scale = nil ---@class Vector2
}

function Methods:Lerp(OtherPivot, Alpha)
    local Offset = self.Offset:Lerp(OtherPivot.Offset, Alpha)
    local Scale = self.Scale:Lerp(OtherPivot.Scale, Alpha)

    return Pivot2D.new(Scale.X, Offset.X, Scale.Y, Offset.Y)
end

function Methods:Is(OtherPivot)
    return self.Scale:Is(OtherPivot.Scale) and self.Offset:Is(OtherPivot.Offset)
end

local Meta = {
    __index = Methods,
    __add = function (t1, t2)
        if type(t1) == "number" then
            return Pivot2D.FromAxises(t1 + t2.Scale, t1 + t2.Offset)
        elseif type(t2) == "number" then
            return Pivot2D.FromAxises(t1.Scale + t2, t1.Offset + t2)
        else
            return Pivot2D.FromAxises(t1.Scale + t2.Scale, t1.Offset + t2.Offset)
        end
    end,
    __sub = function (t1, t2)
        if type(t1) == "number" then
            return Pivot2D.FromAxises(t1 - t2.Scale, t1 - t2.Offset)
        elseif type(t2) == "number" then
            return Pivot2D.FromAxises(t1.Scale - t2, t1.Offset - t2)
        else
            return Pivot2D.FromAxises(t1.Scale - t2.Scale, t1.Offset - t2.Offset)
        end
    end,
    __tostring = function(self)
        return "{"..tostring(self.Scale).."},{"..tostring(self.Offset).."}"
    end
}

---@param Offset Vector2
---@param Scale Vector2
function Pivot2D.FromAxises(Scale, Offset)
    ---@class Pivot2D
    local PivotObject = setmetatable({
        Scale = Scale:Copy(),
        Offset = Offset:Copy(),
    }, Meta)

    return PivotObject
end

function Pivot2D.FromScale(Scale, ScaleY)
    if ScaleY then
        return Pivot2D.new(Scale, 0, ScaleY, 0)
    else
        return Pivot2D.new(Scale.X, 0, Scale.Y, 0)
    end
end

function Pivot2D.FromOffset(Offset, OffsetY)
    if OffsetY then
        return Pivot2D.new(0, Offset, 0, OffsetY)
    else
        return Pivot2D.new(0, Offset.X, 0, Offset.Y)
    end
end

function Pivot2D.FromString(Text)

    local RemoveWhiteSpace = string.gsub(Text,"%s","") -- Strip Whitespace
    local FindBrack = string.gmatch(RemoveWhiteSpace,"{[%d,%-%.]+}")
    local DefaultNumber = 0
    local StringsCreated = {}

    for String in FindBrack do
        local RemoveKeys = string.gsub(String,"[%{%}]","")
        table.insert(StringsCreated,RemoveKeys)
    end

    local FinalString

    if #StringsCreated > 0 then
        FinalString = StringsCreated[1]..","..StringsCreated[2]
    else
        FinalString = Text
    end

    local SplitText = string.split(FinalString,"[%, %s]")

    return Pivot2D.new((tonumber(SplitText[1]) or DefaultNumber),(tonumber(SplitText[3]) or DefaultNumber),(tonumber(SplitText[2]) or DefaultNumber),(tonumber(SplitText[4]) or DefaultNumber))
end

return Pivot2D