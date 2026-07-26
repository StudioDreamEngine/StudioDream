-- Image utilities
local ImageClass = {}

function ImageClass.GetSlices(NineSlice, ImageSize)
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

return ImageClass