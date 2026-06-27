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

    local Text = Runtime.Things.Create("TextInput") {
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 1,
        Pivot = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(0.95,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = MainInfo.Option,
    }

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)

        for i,Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                Text:SetText(Info.Thing[Info.Property])
            else
                Text:SetText("~")
            end
        end
    end

    table.insert(MainInfo.Connections,Text.FocusEnd:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do
            self.Update()
            Runtime.Things.SetProperty(Info.Thing, Info.Property, Text.Text)
            Studio.Layout.CallHandle("Explorer", "Redraw") -- Make this as a attribute thing!!@! 
        end
    end))

    self.Update()

    return self
end



return Template