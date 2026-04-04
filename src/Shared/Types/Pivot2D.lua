local Pivot2D = {}

function Pivot2D.new(OffsetX, ScaleX, OffsetY, ScaleY)
    local PivotObject = {}

    PivotObject.Offset = Vector2.new(OffsetX, OffsetY)
    PivotObject.Scale = Vector2.new(ScaleX, ScaleY)

    return PivotObject
end

-- TODO
function Pivot2D.FromScale(Scale)
    
end

-- TODO
function Pivot2D.FromOffset(Offset)
    return Pivot2D.new(Offset.X, 0, Offset.Y, 0)
end

return Pivot2D