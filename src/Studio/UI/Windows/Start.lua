local Start = {}
local Things = Runtime.Things

function Start.Init()
    local View = Things.Create("Viewport2D") {
        Size = Pivot2D.FromScale(0.98,0.5),
        Position = Pivot2D.FromScale(0.5,0.26),
        Pivot = Vector2.new(0.5,0.5),
        Parent = Start.Container,
        CornerRadius = 5,
    }

    Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(0,0),
        --SquareAxis = Enum.SquareAxis.X,
        Resource = "Internal/Icons/Engine/Update_Thumbs/Early_Rise.png",
        Parent = View,
        ScaleType = Enum.ScaleTypes.Fit
    }

    local Version = Runtime.Things.Create("Text") {
        Text = "Welcome to Early Riser! ("..VERSION..")",
        --ForegroundColor = Studio.Theme.GetCurrentTheme()
        Position = Pivot2D.FromScale(0.05,0),
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1,
        ForegroundTransparency = 0.5,
        Alignment = Vector2.new(0.5,0.5)
    }

    Runtime.Things.Create("Text") {
        Text = "Welcome to Early Riser! ("..VERSION..")",
        ForegroundColor = Color.new(1,1,1),
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(0.5,0.4),
        Pivot = Vector2.new(0.5,0.5),
        Parent = Version,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5)
    }
    --[[local Warning = Runtime.Things.Create("Text") {
        Text = "Do not SHARE or LEAK stuff from here, you are a tester!!!",
        --ForegroundColor = Studio.Theme.GetCurrentTheme()
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1
    }]]

    Version.Size = Pivot2D.FromScale(1,0.05)

    Runtime.InterfaceManager.OnClick:Connect(function()
        Start.FullContainer:SetVisible(false)
    end)
    


end

return Start