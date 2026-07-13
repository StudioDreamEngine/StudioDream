local Template = {}

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

function Template.Start(MainInfo)
    local self = {}
    --MainInfo.Connections

    local Text = Runtime.Things.Create("TextInput") {
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundTransparency = 0,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.CurrentTheme.FontBold,
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
        CornerRadius = 5,
    }

    local ColorBlock = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.8,0.8),
        BackgroundColor = Color.new(1,1,1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = Text,
        ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64)),
        OutlineSize = 1,
        OutlineColor = Studio.Theme.CurrentTheme.Outline
    }

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)
        for i,Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                local ToString = tostring(Info.Thing[Info.Property])
                Text:SetText(ToString)
                ColorBlock.BackgroundColor = Color.FromString(ToString)
            else
                Text:SetText("~")
                Color.BackgroundColor = Color.new(1,1,1,1)
            end
        end
    end

    self.Update()

    table.insert(MainInfo.Connections,Text.FocusEnd:Connect(function()
       --[[ local Obj = Studio.Components.CreateDialog("Color",{
            Text = "Pick a color"
        })
        table.insert(MainInfo.Connections,Obj.FinalProject:Connect(function(Type,Info)]]
            for i,Info in pairs(MainInfo.WillHandle) do
                Runtime.Things.SetProperty(Info.Thing, Info.Property, Color.FromString(Text.Text))
            end
        --end))
    end))

    return self
end

return Template