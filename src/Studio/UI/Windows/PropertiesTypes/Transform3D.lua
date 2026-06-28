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

function CreateTransformNode(MainInfo,WhatThing)
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
            local Transform = Info.Thing.Transform
            local NewMatrix = (WhatThing == "Rotation") and Transform.Rotation.AsAngle().Deg() or Transform.Position

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
            local IsRotate = (WhatThing == "Rotation")
            local FromString = Vector3.FromString(selfed.Option.Text)
            if IsRotate then FromString = FromString.Rad() end

            print(FromString)

            local Transform = Transform3D["From"..(IsRotate and "Angle" or "Position")](FromString)

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
                    MainTxt:SetText("{"..tostring(Info.Thing.Transform.Position).."} {"..tostring(Info.Thing.Transform.Rotation).."}")
                else
                    MainTxt:SetText("~")
                end
            end
        else
            MainTxt:SetText(" ")
        end
    end))
    CreateTransformNode(MainInfo,"Position")
    CreateTransformNode(MainInfo,"Rotation")
    return self
end

return Template