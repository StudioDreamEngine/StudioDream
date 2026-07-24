-- Image utilities
local ImageClass = {}

function ImageClass.GetSlices(NineSlice, ImageSize)
    return {
        { -- Main
            Pos = NineSlice.Min,
            Size = NineSlice.Size
        },

        { -- Top-Left Corner
            Pos = Vector2.zero,
            Size = NineSlice.Min
        },
        { -- Top-Right Corner
            Pos = Vector2.new(NineSlice.Max.X, 0),
            Size = Vector2.new(ImageSize.X - NineSlice.Max.X, NineSlice.Min.Y)
        },
        { -- Bottom-Left Corner
            Pos = Vector2.new(0, NineSlice.Max.Y),
            Size = Vector2.new(NineSlice.Min.X, ImageSize.Y - NineSlice.Max.Y)
        },
        { -- Bottom-Right Corner
            Pos = Vector2.new(NineSlice.Max.X, NineSlice.Max.Y),
            Size = Vector2.new(ImageSize.X - NineSlice.Max.X, ImageSize.Y - NineSlice.Max.Y)
        },

        { -- Left Edge
            Pos = Vector2.new(0, NineSlice.Min.Y),
            Size = Vector2.new(NineSlice.Min.X, NineSlice.Size.Y)
        },
        { -- Right Edge
            Pos = Vector2.new(NineSlice.Max.X, NineSlice.Min.Y),
            Size = Vector2.new(ImageSize.X - NineSlice.Max.X, NineSlice.Size.Y)
        },
        { -- Top Edge
            Pos = Vector2.new(NineSlice.Min.X, 0),
            Size = Vector2.new(NineSlice.Size.X, NineSlice.Min.Y)
        },
        { -- Bottom Edge
            Pos = Vector2.new(NineSlice.Min.X, NineSlice.Max.Y),
            Size = Vector2.new(NineSlice.Size.X, ImageSize.Y - NineSlice.Max.Y)
        },
    }
end

return ImageClass