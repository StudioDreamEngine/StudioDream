-- Image utilities
local InterfaceClass = {}

function InterfaceClass.GetImageSlices(NineSlice, ImageSize)
    return {
        { -- Main
            Pos = NineSlice.Min,
            Size = NineSlice.Size,
            Pivot = Vector2.zero,
            Main = true
        },

        { -- Top-Left Corner
            Pos = Vector2.zero,
            Size = NineSlice.Min,
            Pivot = Vector2.zero
        },
        { -- Top-Right Corner
            Pos = Vector2.new(NineSlice.Max.X, 0),
            Size = Vector2.new(ImageSize.X - NineSlice.Max.X, NineSlice.Min.Y),
            Pivot = Vector2.xAxis
        },
        { -- Bottom-Left Corner
            Pos = Vector2.new(0, NineSlice.Max.Y),
            Size = Vector2.new(NineSlice.Min.X, ImageSize.Y - NineSlice.Max.Y),
            Pivot = Vector2.yAxis
        },
        { -- Bottom-Right Corner
            Pos = Vector2.new(NineSlice.Max.X, NineSlice.Max.Y),
            Size = Vector2.new(ImageSize.X - NineSlice.Max.X, ImageSize.Y - NineSlice.Max.Y),
            Pivot = Vector2.one
        },

        { -- Left Edge
            Pos = Vector2.new(0, NineSlice.Min.Y),
            Size = Vector2.new(NineSlice.Min.X, NineSlice.Size.Y),
            StretchTo = Vector2.new(0, 1),
            Pivot = Vector2.zero
        },
        { -- Right Edge
            Pos = Vector2.new(NineSlice.Max.X, NineSlice.Min.Y),
            Size = Vector2.new(ImageSize.X - NineSlice.Max.X, NineSlice.Size.Y),
            StretchTo = Vector2.new(0,1),
            Origin = Vector2.new(0, NineSlice.Min.Y),
            Pivot = Vector2.xAxis
        },
        { -- Top Edge
            Pos = Vector2.new(NineSlice.Min.X, 0),
            Size = Vector2.new(NineSlice.Size.X, NineSlice.Min.Y),
            StretchTo = Vector2.xAxis,
            Pivot = Vector2.zero
        },
        { -- Bottom Edge
            Pos = Vector2.new(NineSlice.Min.X, NineSlice.Max.Y),
            Size = Vector2.new(NineSlice.Size.X, ImageSize.Y - NineSlice.Max.Y),
            StretchTo = Vector2.xAxis,
            Origin = Vector2.new(NineSlice.Min.X, 0),
            Pivot = Vector2.yAxis
        },
    }
end

-- Taken from https://github.com/weactivist/library-love2d-rounded-rectangle/blob/main/rounded_rectangle.lua
local function _corner(cx, cy, radius, rotation, segments)
    local baseStart = math.pi
    local baseEnd = math.pi * 1.5
    local startAngle = baseStart + rotation
    local endAngle = baseEnd + rotation
    local points = {}

    for i = 0, segments do
        local t = i / segments
        local angle = startAngle + (endAngle - startAngle) * t
        points[#points + 1] = cx + math.cos(angle) * radius
        points[#points + 1] = cy + math.sin(angle) * radius
    end
    return points
end

local function _appendPoints(dest, src)
    for i = 1, #src do
        dest[#dest + 1] = src[i]
    end
end


local function getPoints(width, height, conf)
    local points = {}

    -- Top left corner
    if conf.topLeftRadius > 0 then
        _appendPoints(points, _corner(conf.topLeftRadius, conf.topLeftRadius, conf.topLeftRadius, math.rad(0), conf.segments))
    end

    -- Top edge start
    table.insert(points, conf.topLeftRadius)
    table.insert(points, 0)

    -- Top edge end
    table.insert(points, width - conf.topRightRadius)
    table.insert(points, 0)

    -- Top right corner
    if conf.topRightRadius > 0 then
        _appendPoints(points, _corner(width - conf.topRightRadius, conf.topRightRadius, conf.topRightRadius, math.rad(90), conf.segments))
    end

    -- Right edge
    table.insert(points, width)
    table.insert(points, height - conf.bottomRightRadius)

    -- Bottom right corner
    if conf.bottomRightRadius > 0 then
        _appendPoints(points, _corner(width - conf.bottomRightRadius, height - conf.bottomRightRadius, conf.bottomRightRadius, math.rad(180), conf.segments))
    end

    -- Bottom edge
    table.insert(points, conf.bottomLeftRadius)
    table.insert(points, height)

    -- Bottom left corner
    if conf.bottomLeftRadius > 0 then
        _appendPoints(points, _corner(conf.bottomLeftRadius, height - conf.bottomLeftRadius, conf.bottomLeftRadius, math.rad(270), conf.segments))
    end

    -- Left edge
    table.insert(points, 0)
    table.insert(points, conf.topLeftRadius)

    return points
end

local function LimitCorner(Radius, Size)
    local Size = (Size.X < Size.Y) and Size.X/2 or Size.Y/2
    return (Radius > Size) and Size or Radius
end

---@param Corners Corners
function InterfaceClass.RectWithCorners(Size, Corners, LimitRadius)
    if LimitRadius then
        Corners.BL = LimitCorner(Corners.BL, Size)
        Corners.BR = LimitCorner(Corners.BR, Size)
        Corners.TL = LimitCorner(Corners.TL, Size)
        Corners.TR = LimitCorner(Corners.TR, Size)
    end

    return getPoints(Size.X, Size.Y, {
        topLeftRadius = Corners.TL,
        bottomLeftRadius = Corners.BL,
        topRightRadius = Corners.TR,
        bottomRightRadius = Corners.BR,
        segments = 12
    })
end

return InterfaceClass