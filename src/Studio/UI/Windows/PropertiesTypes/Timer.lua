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

local function FormatTime(Time)
    local totalSeconds = Time or 0

	local minutes = math.floor(totalSeconds / 60)
	local seconds = totalSeconds % 60
	
	return string.format("%d:%02d", minutes, seconds)
end

function Template.Start(MainInfo)
    local self = {}

    local Text = Runtime.Things.Create("TextInput") {
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundTransparency = 1,
        Pivot = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(0.95,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = MainInfo.Option,
    }

    function self.Update(DoesntTimer)
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)
        for i,Info in pairs(MainInfo.WillHandle) do -- on the start it will aways have 1 so ye
            if AllSame then
                Text:SetText((not DoesntTimer) and FormatTime(Info.Thing[Info.Property]) or Info.Thing[Info.Property])
            else
                Text:SetText("~")
            end
        end

    end

    self.Update()

    table.insert(MainInfo.Connections,Text.FocusStart:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do
            print("ahh")
            self.Update(true)
        end
    end))

    table.insert(MainInfo.Connections,Text.FocusEnd:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do
            Runtime.Things.SetProperty(Info.Thing, Info.Property, tonumber(Text.Text))
        end
        self.Update()
    end))

    return self
end

return Template