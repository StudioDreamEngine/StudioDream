return { new = function(Position, Size)
    ---@class Rect
    local Rect = {}

    Rect.Min = Position
    Rect.Max = Position + Size

    Rect.Origin = Position
    Rect.Size = Size

    function Rect.Usable()
        return Rect.Size.Axis() > 0
    end
        
    Rect.Type = "Rect"

    return Rect
end }