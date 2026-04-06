local Pivot2D = {}

function Pivot2D.new(OffsetX, ScaleX, OffsetY, ScaleY)
    local PivotObject = {}

    PivotObject.Offset = Vector2.new(OffsetX, OffsetY)
    PivotObject.Scale = Vector2.new(ScaleX, ScaleY)

    PivotObject.Type = "Pivot2D"

    return PivotObject
end

-- TODO
function Pivot2D.FromScale(Scale, ScaleY)
    if ScaleY then
        return Pivot2D.new(0, Scale, 0, ScaleY)
    else
        return Pivot2D.new(Scale.X, 0, Scale.Y, 0)
    end
end

-- TODO
function Pivot2D.FromOffset(Offset, OffsetY)
    if OffsetY then
        return Pivot2D.new(Offset, 0, OffsetY, 0)
    else
        return Pivot2D.new(Offset.X, 0, Offset.Y, 0)
    end
end

return Pivot2D