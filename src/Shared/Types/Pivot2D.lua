local Pivot2D = {}

function Pivot2D.new(OffsetX, ScaleX, OffsetY, ScaleY)
    Profiler.Start("Pivot2D - Creation")
    local Offset = Vector2.new(OffsetX, OffsetY)
    local Scale = Vector2.new(ScaleX, ScaleY) -- TODO: Rename to Pivot instead of scale
    Profiler.End()
    return Pivot2D.FromAxises(Offset, Scale)
end

---@param Offset Vector2
---@param Scale Vector2
function Pivot2D.FromAxises(Offset, Scale)
    Profiler.Start("Pivot2D - FromAxises")
    ---@class Pivot2D
    local PivotObject = setmetatable({
        Offset = Offset:Copy(),
        Scale = Scale:Copy(),
        Type = "Pivot2D"
    }, {
        __add = function (t1, t2)
            if type(t1) == "number" then
                return Pivot2D.FromAxises(t1 + t2.Offset, t1 + t2.Scale)
            elseif type(t2) == "number" then
                return Pivot2D.FromAxises(t1.Offset + t2, t1.Scale + t2)
            else
                return Pivot2D.FromAxises(t1.Offset + t2.Offset, t1.Scale + t2.Scale)
            end
        end,
        __sub = function (t1, t2)
            if type(t1) == "number" then
                return Pivot2D.FromAxises(t1 - t2.Offset, t1 - t2.Scale)
            elseif type(t2) == "number" then
                return Pivot2D.FromAxises(t1.Offset - t2, t1.Scale - t2)
            else
                return Pivot2D.FromAxises(t1.Offset - t2.Offset, t1.Scale - t2.Scale)
            end
        end,
    })

    function PivotObject:Lerp(OtherPivot, Alpha)
        local Offset = PivotObject.Offset:Lerp(OtherPivot.Offset, Alpha)
        local Scale = PivotObject.Scale:Lerp(OtherPivot.Scale, Alpha)

        return Pivot2D.new(Offset.X, Scale.X, Offset.Y, Scale.Y)
    end

    function PivotObject.Is(OtherPivot)
        return PivotObject.Scale:Is(OtherPivot.Scale) and PivotObject.Offset:Is(OtherPivot.Offset)
    end
    
    Profiler.End()
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