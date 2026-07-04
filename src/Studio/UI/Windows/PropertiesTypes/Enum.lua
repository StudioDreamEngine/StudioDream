local Template = {}

local GeneratedList

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

function GenerateList(Property,Thing,Frame,ChangedOption)
    local EnumMade = Enum[Property]
    local Index = 0
    local Choices = {}

    for i,v in pairs(EnumMade) do
        if type(v) ~= "function" then
           if i ~= "Type" then -- TRUST ME I TRIED "AND" AND IT DIDNT WORK :SKULL:
                Index=Index+1
                print(i,v)
                table.insert(Choices,{ Type = "Separator"})

                table.insert(Choices,{
                    Text = tostring(i),
                    Type = "Button",
                    Function = function()
                        Runtime.Things.SetProperty(Thing, Property, v)
                        ChangedOption.Invoke()
                        GeneratedList.Remove()
                    end
                })
           end
        end
    end

    GeneratedList = Studio.Components.AdvancedDropdown(Choices)
    GeneratedList.Setup(Frame, Vector2.new(0,1))
    GeneratedList.Toggle(true)
end

function Template.Start(MainInfo)
    local self = {}
    --MainInfo.Connections
    self.ChangedOption = Signal:New("BlehBlehhh")

    local Text = Runtime.Things.Create("TextButton") {
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 0,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Primary,
        CornerRadius = 5,
    }

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)

        for i,Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                Text:SetText(Enum[Info.Property].NameFromValue(Info.Thing[Info.Property]))
            else
                Text:SetText("~")
            end
        end
    end

    table.insert(MainInfo.Connections,self.ChangedOption:Connect(function()
        self.Update()
    end))

    table.insert(MainInfo.Connections,Text.Clicked:Connect(function()
        if GeneratedList then GeneratedList.Remove() end

        for i,Info in pairs(MainInfo.WillHandle) do
            GenerateList(Info.Property,Info.Thing,Text,self.ChangedOption)
        end
    end))

    return self
end

return Template
