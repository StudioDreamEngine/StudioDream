local Size = Vector2.new(64,64)
local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

local IsOpen = false
local CreatedNodes = {}

local function CreateOption(FrameOption,Name,Value,Thing,PropertyGiven)
    print(Value)
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
        ForegroundColor = Studio.Theme.Text
    }

    local Option = Runtime.Things.Create("TextInput") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.49,1),
        Position = Pivot2D.FromScale(0.51,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.Outline,
        Layer = 3,
        Name = "Frame",
        Text = tostring(Vector3.new(Value.X,Value.Y,Value.Z)),
        Parent = BaseProperty,
        ForegroundColor = Studio.Theme.Text
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

    Option.FocusEnd:Connect(function()
        local ToFilter = string.gsub(Option.Text,"%a","")
        local SplitVecText = string.split(ToFilter,",")

        Thing:SetTransform(Transform3D["From"..Name](tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01,tonumber(SplitVecText[3])or 0.01))
        Option.Text = tostring(Vector3.new(tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01,tonumber(SplitVecText[3])or 0.01))
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

return function(FrameOption,Thing,Property,ActualNode)
    print(Thing[Property])
    local Button = Runtime.Things.Create("Image2D") {
        Image = "Assets/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = FrameOption,
    }
    ChangeButton(Button,IsOpen)
    CreateOption(FrameOption,"Position",Thing[Property].Position,Thing,Property)
    --CreateOption(FrameOption,"Angle",Thing[Property].Position,Thing,Property)
end