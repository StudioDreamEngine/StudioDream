local Rect = {}

function Rect.new(Position, Size)
    ---@class Rect
    local RectObject = {}

    RectObject.Min = Position
    RectObject.Max = Position + Size

    RectObject.Origin = Position
    RectObject.Size = Size

    function RectObject.Usable()
        return RectObject.Size:Axis() > 0
    end
        
    RectObject.Type = "Rect"

    return setmetatable(RectObject,{
        __tostring = function(self)
            return "{"..tostring(RectObject.Origin).."} , {"..tostring(RectObject.Size).."}"
        end,
        __add = function(t1,t2)
            if type(t2) == "number" then
                return Rect.new(t1.Origin+t2,t1.Size+t2)
            elseif Utils.TypeOf(t2) == "Rect" then
                return Rect.new(t1.Origin+t2.Origin,t1.Size+t2.Size)
            else
                assert("Rect expected, got ("..Utils.TypeOf(t2)..")")
            end
        end
    })
end

function Rect.FromString(Text)
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

    for Index, Text in pairs(SplitText) do
        SplitText[Index] = tonumber(Text) or DefaultNumber
    end

    return Rect.new(Vector2.new(SplitText[1],SplitText[2]),Vector2.new(SplitText[3],SplitText[4]))
end

return Rect