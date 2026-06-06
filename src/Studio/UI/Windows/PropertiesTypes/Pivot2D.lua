local Size = Vector2.new(64,64)

local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

return function(FrameOption,Thing,Property,ActualNode)
    print(Thing[Property])

    local IsOpen = true
    local CreatedNodes = {}

    local function CreateOption(FrameOption,Name,Value,Thing,PropertyGiven)
        
    local BaseProperty = Runtime.Things.Create("Square") { 
        Size = Pivot2D.new(0,1,15,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Parent = FrameOption.Parent.Parent,
        ListOrder = FrameOption.Parent.ListOrder+0.1,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.Outline
    }

    Runtime.Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.05,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = Name,
        Name = "PropertyName",
        Parent = BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text2
    }

    local Option = Runtime.Things.Create("TextInput") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.49,1),
        Position = Pivot2D.FromScale(0.51,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Name = "Frame",
        Text = tostring(Vector2.new(Value.X,Value.Y)),
        Parent = BaseProperty,
        ForegroundColor = Studio.Theme.Text2
    }

    Runtime.Things.Create("Square") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.015,0.85),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.Theme.Primary,
        Layer = 3,
        Name = "Frame",
        Parent = BaseProperty,
    }

    CreatedNodes[Name] = BaseProperty

    Option.FocusEnd:Connect(function()
        local ToFilter = string.gsub(Option.Text,"%a","")
        local SplitVecText = string.split(ToFilter,",")

        --Thing:SetTransform(Transform3D["From"..Name](tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01,tonumber(SplitVecText[3])or 0.01))
        Option.Text = tostring(Vector2.new(tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01))
    end)

    Thing.PropertyChanged:Connect(function(NewVal,WhatProperty)
        if WhatProperty == "Transform" then
            Option:SetText(tostring(NewVal[Name]))
        end
    end)

    end


    local function ChangeButton(But,Property)
        But:SetImageRect(Rect.new(LineUp[tostring(Property)],Size))
    end

    local Button = Runtime.Things.Create("ImageButton") {
        Resource = "Assets/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Studio.Theme.Text,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = FrameOption,
    }

    local TextToEverythin = Runtime.Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = "",
        Parent = FrameOption,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text2
    }

    ChangeButton(Button,IsOpen)
    print(Thing[Property])

    Button.Clicked:Connect(function()
        IsOpen = not IsOpen
        ChangeButton(Button,IsOpen)
        for i,v in pairs(CreatedNodes) do
            v.Visible = IsOpen
        end

        TextToEverythin:SetText((not IsOpen) and ("{"..tostring(Thing[Property].Scale).."}".."{"..tostring(Thing[Property].Offset).."}") or "")
        
    end)

    CreateOption(FrameOption,"Scale",Thing[Property].Scale,Thing,Property)
    CreateOption(FrameOption,"Offset",Thing[Property].Offset,Thing,Property)
    --CreateOption(FrameOption,"Angle",Thing[Property].Position,Thing,Property)]]
end