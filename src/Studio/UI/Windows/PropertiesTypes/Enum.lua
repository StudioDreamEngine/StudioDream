local Bool = {}

local function CheckAllTheSame(table)
    local FirtaVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirtaVal then
            return false
        end
    end
    return true
end

function Bool.Start(MainInfo)
    local self = {}

    local Text = Runtime.Things.Create("TextButton") {
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Primary,
        Alignment = Enum.Alignment.Center,
        Pivot = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = MainInfo.Option,
        CornerRadius = 5,
    }

    local Expand = Runtime.Things.Create("Image2D") {
        Resource = "Internal/Studio/OpenMenu.png",
        Size = Pivot2D.FromScale(0.8,0.8),
        BackgroundTransparency = 1,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = Text,
        ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64))
    }

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)

        for i,Info in pairs(MainInfo.WillHandle) do
            local Thing = Info.Thing ---@class Thing

            if AllSame then
                Text:SetText(Thing[Info.Property])
            else
                Text:SetText("~")
            end
        end
    end

    local IsOpen = false

    table.insert(MainInfo.Connections, Text.Clicked:Connect(function()
        IsOpen = not IsOpen
        
        Expand:SetImageRect(Rect.new(
            Vector2.new(IsOpen and 64 or 0, 0),
            Vector2.new(64,64)
        ))
    end))

    self.Update()

    return self
end

return Bool