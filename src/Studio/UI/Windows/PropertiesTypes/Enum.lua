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

function GenerateList(MainInfo,ChangedOption,Things,Property)
    local RefObject = Things[1].Thing
    local EnumList = RefObject.Proxy.Enums[Property]

    local Index = 0
    local Choices = {}
    for i,v in pairs(EnumList) do
        if type(v) ~= "function" then
           if i ~= "Type" then -- TRUST ME I TRIED "AND" AND IT DIDNT WORK :SKULL:
                Index=Index+1
                print(i,v)
                table.insert(Choices,{ Type = "Separator"})

                table.insert(Choices, {
                    Text = tostring(i),
                    Type = "Button",
                    Function = function()
                        for i,Info in pairs(Things) do
                            Runtime.Things.SetProperty(Info.Thing, Property, v)
                        end

                        ChangedOption.Invoke()

                        if GeneratedList then 
                            GeneratedList.Remove() 
                            GeneratedList = nil
                        end
                    end
                })
           end
        end
    end

    return Choices
end

function Template.Start(MainInfo)
    local self = {}
    local EnumLock = false
    --MainInfo.Connections
    self.ChangedOption = Signal:New("BlehBlehhh")

    local Text = Runtime.Things.Create("TextButton") {
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundTransparency = 0,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.CurrentTheme.FontBold,
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
        CornerRadius = 5,
    }

    function self.Update()
        local AllSame = CheckAllTheSame(MainInfo.WillHandle)

        for i,Info in pairs(MainInfo.WillHandle) do
            if AllSame then
                ---@class Thing
                local Thing = Info.Thing
                local EnumList = Thing.Proxy.Enums[Info.Property]

                Text:SetText(EnumList.NameFromValue(Info.Thing[Info.Property])) -- Gonna have to do it the shitty way for now until we have an enum rewrite
            else
                Text:SetText("~")
            end
        end
    end

    function self.Destroy()
        if GeneratedList then 
            GeneratedList.Remove() 
            GeneratedList = nil
        end
    end
    
    self.Update()

    table.insert(MainInfo.Connections,self.ChangedOption:Connect(function()
        EnumLock=false
    end))

    table.insert(MainInfo.Connections,Text.Clicked:Connect(function()

        local AllSame = CheckAllTheSame(MainInfo.WillHandle)
        local TableWow = {}

        if AllSame then
            local PropertyOne
            for i,Info in pairs(MainInfo.WillHandle) do
                PropertyOne = Info.Property
                table.insert(TableWow,{
                    Thing = Info.Thing,
                })
            end

            EnumLock = not EnumLock

            if EnumLock then
                local ListGenerated = GenerateList(MainInfo,self.ChangedOption,TableWow,PropertyOne)
                --print(ListGenerated)
                GeneratedList = Studio.Components.DropdownPlus.new(ListGenerated,Text)
            else
                if GeneratedList then 
                    GeneratedList.Remove() 
                    GeneratedList = nil
                end
            end
        end
    end))

    return self
end

return Template
