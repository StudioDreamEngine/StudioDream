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

    return RectObject
end

function Rect.FromString(Text)
    local RemoveWhiteSpace = string.gsub(Text,"%s","") -- Strip Whitespace
    local FindBrack = string.gmatch(RemoveWhiteSpace,"{[%d,]+}")
    local DefaultNumber = 0
    local StringsCreated = {}

    for String in FindBrack do
        local RemoveKeys = string.gsub(String,"[%{ %}]","")
        table.insert(StringsCreated,RemoveKeys)
    end

    local FinalString

    if #StringsCreated > 0 then
        FinalString = StringsCreated[1]..","..StringsCreated[2]
    else
        FinalString = Text
    end
    
    local SplitText = string.split(FinalString,"[%, %s]")

    return Rect.new(Vector2.new((SplitText[1] or DefaultNumber),(SplitText[1] or DefaultNumber)),Vector2.new((SplitText[3] or DefaultNumber),(SplitText[4] or DefaultNumber)))
end

return Rect