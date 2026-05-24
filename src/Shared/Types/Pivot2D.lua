local Pivot2D = {}

function Pivot2D.new(OffsetX, ScaleX, OffsetY, ScaleY)
    ---@class Pivot2D
    local PivotObject = {}

    PivotObject.Offset = Vector2.new(OffsetX, OffsetY)
    PivotObject.Scale = Vector2.new(ScaleX, ScaleY) -- TODO: Rename to Pivot instead of scale

    PivotObject.Type = "Pivot2D"

    function PivotObject.Lerp(OtherPivot, Alpha)
        local Offset = PivotObject.Offset.Lerp(OtherPivot.Offset, Alpha)
        local Scale = PivotObject.Scale.Lerp(OtherPivot.Scale, Alpha)

        return Pivot2D.new(Offset.X, Scale.X, Offset.Y, Scale.Y)
    end

    return PivotObject
end

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