local GeneratedList
local ChangedOption = Signal:New("BlehBleh")

local function GenerateList(Option,Frame,Thing)
    local Enum = Enum[Option]
    local Index = 0
    local FrameScaleBy = Runtime.Things.Create("Square") {
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(1,1),
        Parent = Frame,
        BackgroundColor = Studio.Theme.Secondary,
        Layer = 90,
    }
    Runtime.Things.Create("ListLayout") {
        Parent = FrameScaleBy,
    }
    for i,v in pairs(Enum) do
        Index=Index+1
        local SelfFunc
        local Button2 = Runtime.Things.Create("TextButton") {
            Text = tostring(i),
            ForegroundColor = Studio.Theme.Text,
            BackgroundColor = Studio.Theme.Thirdry,
            Size = Pivot2D.FromScale(1,0.15),
            ListOrder = Index,
            OutlineSize = 1,
            OutlineColor = Studio.Theme.Outline,
            Parent = FrameScaleBy
        }
        SelfFunc = Button2.Clicked:Connect(function()
            Thing[Option] = v
            ChangedOption.Invoke()
            SelfFunc:Disconnect()
            Runtime.Things.Remove(GeneratedList)
        end)
        FrameScaleBy:SetSize(Pivot2D.FromScale(1,Index))
    end
    GeneratedList = FrameScaleBy
end
local Size = Vector2.new(64,64)
local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(0,0),
}
local function ChangeButton(But,Property)
    But:SetImageRect(Rect.new(LineUp[tostring(Property)],Size))
end
return function(FrameOption,Thing,Property) 
    local EnumLock = false
    local ConnectFunction
    
    local TextClick = Runtime.Things.Create("TextButton") {
        Text = tostring(Utils.GetEnumNameByValue(Property,Thing[Property])),
        ForegroundColor = Studio.Theme.Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = FrameOption
    }
    local Button = Runtime.Things.Create("Image2D") {
        Image = "Assets/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = TextClick,
    }

   --[[ local OgPos = Button.Position
    Button.Position.Scale = Pivot2D.FromScale(Button.Position.Scale.X,Button.Position.Scale.Y-0.05)
    Runtime.Services.Service("Tween").Create(0.5,Button,{Position = OgPos},Enum.EasingStyle.Sine,Enum.EasingMode.Out)]]
    ChangeButton(Button,EnumLock)

    TextClick.Clicked:Connect(function()
        print(EnumLock)
        if not ConnectFunction then
            ConnectFunction = ChangedOption:Connect(function()
                print("Bleh")
                TextClick.Text = tostring(Utils.GetEnumNameByValue(Property,Thing[Property]))
                EnumLock = false
            end)
        end
        EnumLock = not EnumLock
        ChangeButton(Button,EnumLock)
        if not EnumLock then Runtime.Things.Remove(GeneratedList) else GenerateList(Property,FrameOption,Thing) end
    end)

end