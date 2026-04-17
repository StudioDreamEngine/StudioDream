return { new = function(Position, Size)
    return {
        Min = Position,
        Max = Position + Size,
        Type = "Rect"
    }
end }