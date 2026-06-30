local Start = {}
local Things = Runtime.Things

function Start.CreateProject(Scroll,Info,Path,FullContainer)
    local selfed = {}

    selfed.Base = Runtime.Things.Create("TextButton") {
        Text = "",
        Size = Pivot2D.FromScale(0.95,0.2),
        Parent = Scroll,
        Layer = 2,
        CornerRadius = 5,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
    }

    selfed.Image = Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(.07,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/Update_Thumbs/Early_Riser.png",
        Parent = selfed.Base,
        Pivot = Vector2.new(.5,.5),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    }

    selfed.ProjectName = Runtime.Things.Create("Text") {
        Text = Info.Name,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        Position = Pivot2D.FromScale(0,0),
        Parent = selfed.Base,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,0.5),
        Font = Studio.Theme.GetCurrentTheme().FontBold,
    }

    selfed.Date = Runtime.Things.Create("Text") {
        Text = "Last Mod: "..Utils.TimeAgo(Info.Time),
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        Position = Pivot2D.FromScale(0,0.5),
        Parent = selfed.Base,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,0.5)
    }

    selfed.Base.Clicked:Connect(function()
        print("Click")
        Runtime.Project.Load(Path)
        FullContainer:SetVisible(false)
    end)


    return selfed
end

function Start.CreateButton(Options,Text,Image)
    local selfed = {}

    selfed.Base = Runtime.Things.Create("TextButton") {
        Text = Text,
        Size = Pivot2D.FromScale(0.95,0.15),
        Parent = Options,
        Layer = 2,
        CornerRadius = 5,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        OutlineSize = 2,
        Alignment = Vector2.new(1,0.5),
        TextSize = 5,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
    }

    selfed.Image = Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(.07,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = Image,
        Parent = selfed.Base,
        Pivot = Vector2.new(.5,.5),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    }
    return selfed
end

function Start.Close()
    Start.FullContainer:SetVisible(false)
    Studio.Components.HideFade()
end

function Start.Init()
    Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,0.5),
        Position = Pivot2D.FromScale(.5,.005),
        --SquareAxis = Enum.SquareAxis.X,
        Resource = "Internal/Studio/Update_Thumbs/Early_Riser.png",
        Parent = Start.Container,
        Pivot = Vector2.new(.5,0),
        CornerRadius = 5,
        ScaleType = Enum.ScaleType.Crop
    }
    
    Studio.Components.ShowFade(Start.Close)

    local Version = Runtime.Things.Create("Text") {
        Text = "Welcome to Early Riser! ("..VERSION..") (This is a wip window, nothin works sorrey)",
        ForegroundColor = Studio.Theme.GetCurrentTheme().TextInverse,
        Position = Pivot2D.FromScale(0.05,0),
        Size = Pivot2D.FromScale(1,0.1),
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5)
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

    local Scroll = Runtime.Things.Create("ScrollContainer") {
        Size = Pivot2D.FromScale(1,1),
        Parent = RecentProjects,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
    }

    Things.Create("ListLayout") {
        Parent = Scroll,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 3
    }

    Things.Create("ListLayout") {
        Parent = Options,
        Alignment = Enum.Alignment.Center,
        Padding = 5
    }

    --[[local Warning = Runtime.Things.Create("Text") {
        Text = "Do not SHARE or LEAK stuff from here, you are a tester!!!",
        --ForegroundColor = Studio.Theme.GetCurrentTheme()
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1
    }]]

    Start.CreateButton(Options,"Create new project.","Internal/Studio/AddThing.png")
    Start.CreateButton(Options,"Upload a project","Internal/Studio/TabIcons/InsertIcon.png")
    local wow = Start.CreateButton(Options,"Close Window","Internal/Studio/Placeholders/Jeremy.png")

    wow.Base.Clicked:Connect(Start.Close)

    Version.Size = Pivot2D.FromScale(1,0.05)

    for i,v in pairs(Runtime.SettingsManager.GetSetting("RecentProjects")) do
        Start.CreateProject(Scroll,v,i,Start.FullContainer)
    end

end

return Start