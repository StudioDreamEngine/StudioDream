return { new = function(Position, Size)
    return {
        Min = Position,
        Max = Position + Size,

        Origin = Position,
        Size = Size,
        
        Type = "Rect"
    }
end }