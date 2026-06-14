local Transform3Dee = {}

Transform3Dee.CustomConnect = "Transform"

local Size = Vector2.new(64,64)

local IsOpen = true
local CreatedNodes = {}

local SomethingUpdated = Signal:New("Wow")

local function CreateOption(FrameOption,Name,Value,Thing,PropertyGiven)
    --print(Value)
    local BaseProperty = Runtime.Things.Create("Square") { 
        Size = Pivot2D.new(0,1,15,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = FrameOption.Parent.Parent,
        ListOrder = FrameOption.Parent.ListOrder+0.1,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }

    Runtime.Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.05,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = Name,
        Name = "PropertyName",
        Parent = BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2
    }

    local Option = Runtime.Things.Create("TextInput") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.49,1),
        Position = Pivot2D.FromScale(0.51,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Name = "Frame",
        Text = tostring(Vector3.new(Value.X,Value.Y,Value.Z)),
        Parent = BaseProperty,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2
    }

    Runtime.Things.Create("Square") { -- The frame where options will be in, aka textlabel for strings, tables open and close ect ect!!!
        Size = Pivot2D.FromScale(0.015,0.85),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Primary,
        Layer = 3,
        Name = "Frame",
        Parent = BaseProperty,
    }

    CreatedNodes[Name] = BaseProperty

    Option.FocusEnd:Connect(function()
        local ToFilter = string.gsub(Option.Text,"%a","")
        local SplitVecText = string.split(ToFilter,",")

        Thing:SetTransform(Transform3D["From"..Name](tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01,tonumber(SplitVecText[3])or 0.01))
        Option.Text = tostring(Vector3.new(tonumber(SplitVecText[1]) or 0.01,tonumber(SplitVecText[2])or 0.01,tonumber(SplitVecText[3])or 0.01))
    end)

    SomethingUpdated:Connect(function(NewVal)
        --print("Hi")
        Option:SetText(tostring(NewVal[Name]))
    end)

end

local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}

local function ChangeButton(But,Property)
    But:SetImageRect(Rect.new(LineUp[tostring(Property)],Size))
end

function Transform3Dee.Start(FrameOption,Thing,Property,ActualNode)
    --print(Thing[Property])

    local Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Text,
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
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2
    }
    ChangeButton(Button,IsOpen)
    Button.Clicked:Connect(function()
        IsOpen = not IsOpen
        ChangeButton(Button,IsOpen)
        for i,v in pairs(CreatedNodes) do
            v.Visible = IsOpen
        end

        TextToEverythin:SetText((not IsOpen) and ("{"..tostring(Thing[Property].Position).."}") or "")
        
    end)
    CreateOption(FrameOption,"Position",Thing[Property].Position,Thing,Property)
    --CreateOption(FrameOption,"Angle",Thing[Property].Position,Thing,Property)
end

function Transform3Dee.Update(NewValue)
    SomethingUpdated.Invoke(NewValue)
end

return Transform3Dee