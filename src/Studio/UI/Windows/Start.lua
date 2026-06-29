local Start = {}
local Things = Runtime.Things

function Start.Init()
    Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(0.7,0.5),
        Position = Pivot2D.FromScale(.5,.005),
        --SquareAxis = Enum.SquareAxis.X,
        Resource = "Internal/Studio/Update_Thumbs/Early_Riser.png",
        Parent = Start.Container,
        Pivot = Vector2.new(.5,0),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    }
    
    local Back = Runtime.Things.Create("Square") { 
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Color.new(0,0,0),
        Name = "WindowContainer",
        Layer = 999,
        Parent = Runtime.Things.GetRootViewport(),
        BackgroundTransparency = 0.5,
        CornerRadius = 5,
    }

    Start.FullContainer:SetParent(Back)

    local Version = Runtime.Things.Create("Text") {
        Text = "Welcome to Early Riser! ("..VERSION..")",
        ForegroundColor = Studio.Theme.GetCurrentTheme().TextInverse,
        Position = Pivot2D.FromScale(0.05,0),
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5)
    }

    local Close = Runtime.Things.Create("TextButton") {
        Text = "Close TS",
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Size = Pivot2D.FromScale(.05,.05),
        Parent = Start.Container,
        Alignment = Vector2.new(0.5,0.5),
        Layer = 2,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        CornerRadius = 5,
        Font = Studio.Theme.GetCurrentTheme().Bold,
        TextSize = 20
    }

    local Options = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.48,0.48),
        Parent = Start.Container,
        Layer = 2,
        CornerRadius = 5,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.25,.75),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
    }

    local RecentProjects = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.48,0.48),
        Parent = Start.Container,
        Layer = 2,
        CornerRadius = 5,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.75,.75),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
    }
    --[[local Warning = Runtime.Things.Create("Text") {
        Text = "Do not SHARE or LEAK stuff from here, you are a tester!!!",
        --ForegroundColor = Studio.Theme.GetCurrentTheme()
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1
    }]]

    Version.Size = Pivot2D.FromScale(1,0.05)

    Close.Clicked:Connect(function()
        Start.FullContainer:SetVisible(false)
        Back:SetVisible(false)
    end)
    --[[Runtime.InterfaceManager.OnClick:Connect(function()
        Start.FullContainer:SetVisible(false)
    end)]]    


end

return Start