local Template = {}
local Things = Runtime.Things

local UpdateSignal

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

function CreatePivotNode(MainInfo,WhatThing)
    local selfed = {}
    selfed.BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,0.95,23,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = MainInfo.Expand.Container,
        CornerRadius = 6,
    }

    selfed.Option = Things.Create("TextInput") {
        Size = Pivot2D.FromScale(0.49,.8),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 3,
        Parent = selfed.BaseProperty,
        CornerRadius = 6,
         ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }

    selfed.Text = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.49,.9),
        Position = Pivot2D.FromScale(0.005,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = WhatThing,
        Parent = selfed.BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }
    
    local function Update()
        for i,Info in pairs(MainInfo.WillHandle) do
        if CheckAllTheSame(MainInfo.WillHandle) then
            local Transform = Info.Thing[Info.Property]
            local NewMatrix = (WhatThing == "Scale") and Transform.Scale  or Transform.Offset

            selfed.Option:SetText(tostring(NewMatrix))
        else
            selfed.Option:SetText("~")
        end
    end
    end

    Update()

    table.insert(MainInfo.Connections,UpdateSignal:Connect(function()
        Update()
    end))

    table.insert(MainInfo.Connections,selfed.Option.FocusEnd:Connect(function()
        for i,Info in pairs(MainInfo.WillHandle) do
            local IsRotate = (WhatThing == "Offset")
            local FromString = Vector2.FromString(selfed.Option.Text)

            print(FromString)

            local Transform = IsRotate and Pivot2D.new(FromString.X,Info.Thing[Info.Property].Scale.X,FromString.Y,Info.Thing[Info.Property].Scale.Y) or Pivot2D.new(Info.Thing[Info.Property].Offset.X,FromString.X,Info.Thing[Info.Property].Offset.Y,FromString.Y)

            Things.SetProperty(Info.Thing, Info.Property, Transform)
        end
    end))

    return selfed
end

function Template.Start(MainInfo)
    local self = {}
    --MainInfo.Connections
    MainInfo.ParentWith = MainInfo.BaseProperty.Parent
    local MainTxt = Runtime.Things.Create("Text") {
        Text = " ",
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
    }

    local Expand = Studio.Components.ExpandableDropdown(MainInfo.Option, MainInfo.ParentWith)

    MainInfo.Expand = Expand
    UpdateSignal = Signal:New("Update")

    function self.Update()
        UpdateSignal.Invoke()
    end

    table.insert(MainInfo.Connections,MainInfo.Expand.VisibleChanged:Connect(function(Visible)
        if not Visible then
            for i,Info in pairs(MainInfo.WillHandle) do
                if CheckAllTheSame(MainInfo.WillHandle) then
                    MainTxt:SetText("{"..tostring(Info.Thing[Info.Property].Scale).."} {"..tostring(Info.Thing[Info.Property].Offset).."}")
                else
                    MainTxt:SetText("~")
                end
            end
        else
            MainTxt:SetText(" ")
        end
    end))
    CreatePivotNode(MainInfo,"Scale")
    CreatePivotNode(MainInfo,"Offset")
    return self
end

return Template