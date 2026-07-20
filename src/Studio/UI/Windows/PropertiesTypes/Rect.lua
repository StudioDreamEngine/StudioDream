local Rected = {}
local Things = Runtime.Things

local UpdateSignal = Signal:New("Update_Cool")

local function CheckAllTheSame(table)
    local FirstVal = table[1] and table[1].Thing[table[1].Property]
    for i, Info in pairs(table) do
        if Info.Thing[Info.Property] ~= FirstVal then
            return false
        end
    end
    return true
end

local function CreatePivotNode(MainInfo,WhatThing)
    local selfed = {}
    selfed.BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,0.95,23,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        Layer = 3,
        Parent = MainInfo.Expand.Container,
        CornerRadius = 6,
    }

    selfed.Option = Things.Create("TextInput") {
        Size = Pivot2D.FromScale(0.49,.8),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
        Layer = 3,
        Parent = selfed.BaseProperty,
        CornerRadius = 6,
         ForegroundColor = Studio.Theme.CurrentTheme.Text
    }

    selfed.Text = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.49,.9),
        Position = Pivot2D.FromScale(0.005,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = WhatThing,
        Parent = selfed.BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.CurrentTheme.Text
    }
    
    local function Update()
        for i,Info in pairs(MainInfo.WillHandle) do
            if CheckAllTheSame(MainInfo.WillHandle) then
                local Transform = Info.Thing[Info.Property]
                local NewMatrix = (WhatThing == "Origin" and (Transform and Transform.Origin or "???") or (Transform and Transform.Size or "???"))

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
            local IsRotate = (WhatThing == "Origin")
            local FromString = Vector2.FromString(selfed.Option.Text)

            print(FromString)

            local Transform = IsRotate and Rect.new(FromString,(Info.Thing[Info.Property].Size or Vector2.zero)) or Rect.new((Info.Thing[Info.Property].Origin or Vector2.zero),FromString)

            Things.SetProperty(Info.Thing, Info.Property, Transform)
        end
    end))

    return selfed
end

function Rected.Start(MainInfo)
    local self = {}
    --MainInfo.Connections
    MainInfo.ParentWith = MainInfo.BaseProperty.Parent
    local MainText = Runtime.Things.Create("Text") {
        Text = " ",
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.CurrentTheme.FontBold,
    }

    local Expand = Studio.Components.ExpandableDropdown(MainInfo.Option, MainInfo.ParentWith)

    MainInfo.Expand = Expand

    function self.Update()
        UpdateSignal.Invoke()
    end

    table.insert(MainInfo.Connections,MainInfo.Expand.VisibleChanged:Connect(function(Visible)
        if not Visible then
            for i,Info in pairs(MainInfo.WillHandle) do
                if CheckAllTheSame(MainInfo.WillHandle) then
                    local NotTransform = "{???} {???} ~ Set a Rect by here or by an script"
                    local Text = Info.Thing[Info.Property] and ("{"..tostring(Info.Thing[Info.Property].Origin).."} {"..tostring(Info.Thing[Info.Property].Size).."}") or NotTransform
                    MainText:SetText(Text)
                else
                    MainText:SetText("~")
                end
            end
        else
            MainText:SetText(" ")
        end
    end))
    CreatePivotNode(MainInfo,"Origin")
    CreatePivotNode(MainInfo,"Size")
    return self
end

return Rected