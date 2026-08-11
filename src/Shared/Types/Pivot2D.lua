local Pivot2D = {}

function Pivot2D.new(OffsetX, ScaleX, OffsetY, ScaleY)
    local Offset = Vector2.new(OffsetX, OffsetY)
    local Scale = Vector2.new(ScaleX, ScaleY) -- TODO: Rename to Pivot instead of scale
    
    return Pivot2D.FromAxises(Offset, Scale)
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

    return Pivot2D.new(Offset.X, Scale.X, Offset.Y, Scale.Y)
end

function Methods:Is(OtherPivot)
    return self.Scale:Is(OtherPivot.Scale) and self.Offset:Is(OtherPivot.Offset)
end

local Meta = {
    __index = Methods,
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
}

---@param Offset Vector2
---@param Scale Vector2
function Pivot2D.FromAxises(Offset, Scale)
    ---@class Pivot2D
    local PivotObject = setmetatable({
        Offset = Offset:Copy(),
        Scale = Scale:Copy(),
    }, Meta)

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