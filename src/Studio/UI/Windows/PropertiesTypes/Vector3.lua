-- literall just for testing - bloctans
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

        for i,Info in pairs(MainInfo.WillHandle) do -- on the start it will aways have 1 so ye
            if AllSame then
                Text:SetText(tostring(Info.Thing[Info.Property]))
            else
                Text:SetText("~")
            end
        end

    end

    self.Update()

    table.insert(MainInfo.Connections,Text.FocusEnd:Connect(function()
            for i,Info in pairs(MainInfo.WillHandle) do
                Runtime.Things.SetProperty(Info.Thing, Info.Property, tonumber(Text.Text))
            end
        end))

    return self
end

return Template