local Start = {}
local Things = Runtime.Things

function Start.CreateProject(Scroll,Info,Path,FullContainer)
    local selfed = {}

    local ImageToUse
    if Utils.FileExists(Path.."Thumbnail.png") then
        ImageToUse = Path.."Thumbnail.png"
    else
        ImageToUse = "Internal/Studio/Update_Thumbs/Early_Riser.png"
    end

    selfed.Base = Runtime.Things.Create("TextButton") {
        Text = "",
        Size = Pivot2D.FromScale(0.95,0.2),
        Parent = Scroll,
        Layer = 2,
        CornerRadius = 5,
        BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.CurrentTheme.Outline,
    }

    selfed.Image = Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(.07,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = ImageToUse,
        Parent = selfed.Base,
        Pivot = Vector2.new(.5,.5),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    }

    selfed.ProjectName = Runtime.Things.Create("Text") {
        Text = Info.Name,
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        Position = Pivot2D.FromScale(0,0),
        Parent = selfed.Base,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,0.5),
        Font = Studio.Theme.CurrentTheme.FontBold,
    }

    selfed.Date = Runtime.Things.Create("Text") {
        Text = "Last Mod: "..Utils.TimeAgo(Info.Time),
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        Position = Pivot2D.FromScale(0,0.5),
        Parent = selfed.Base,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,0.5)
    }

    selfed.Base.Clicked:Connect(function()
        Runtime.Project.Load(Path)
        Start.Close()
        Studio.Layout.CallHandle("Explorer", "Redraw")
    end)


    return selfed
end

function Start.CreateButton(Options,Text,Image)
    local selfed = {}

    local Base = Runtime.Things.Create("TextButton") {
        Text = Text,
        Size = Pivot2D.FromScale(0.95,0.15),
        Parent = Options,
        Layer = 2,
        CornerRadius = 5,
        BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
        OutlineSize = 2,
        Alignment = Vector2.new(1,0.5),
        TextSize = 5,
        OutlineColor = Studio.Theme.CurrentTheme.Outline,
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
    }

    selfed.Image = Runtime.Things.Create("Image2D") {
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(.07,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = Image,
        Parent = Base,
        Pivot = Vector2.new(.5,.5),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    }

    return Base
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
    
    Studio.Components.ShowFade()--Start.Close)

    local Version = Runtime.Things.Create("Text") {
        Text = "Welcome to Early Riser! ("..VERSION..")",
        ForegroundColor = Studio.Theme.CurrentTheme.TextInverse,
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
        BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.CurrentTheme.Outline,
    }

    local RecentProjects = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.48,0.48),
        Parent = Start.Container,
        Layer = 2,
        CornerRadius = 5,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.75,.75),
        BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.CurrentTheme.Outline,
    }

    local Scroll = Runtime.Things.Create("ScrollContainer") {
        Size = Pivot2D.FromScale(1,1),
        Parent = RecentProjects,
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
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
        --ForegroundColor = Studio.Theme.CurrentTheme
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1
    }]]

    local NewProject = Start.CreateButton(Options,"Create new project.","Internal/Studio/AddThing.png")
    local LoadProject = Start.CreateButton(Options,"Load a project","Internal/Studio/TabIcons/InsertIcon.png")

    NewProject.Clicked:Connect(function()
        --Studio.ProjectManager.NewProject("Demo Project")
        local Cool = Studio.Components.CreateDialog("Input",{
            Text = "Input a name for your new project"
        })
        Start.Close()
        
        Cool.FinalProject:Connect(function(ProjectName)
            Studio.ProjectManager.NewProject(ProjectName)
            Studio.Layout.CallHandle("Explorer", "Redraw")
        end)
    end)

    LoadProject.Clicked:Connect(function()
        Studio.ProjectManager.LoadProject(Start.Close)
        Studio.Layout.CallHandle("Explorer", "Redraw")
    end)

    --local wow = Start.CreateButton(Options,"Close Window","Internal/Studio/Placeholders/Jeremy.png")
    --wow.Clicked:Connect(Start.Close)

    Version.Size = Pivot2D.FromScale(1,0.05)

    for i,v in pairs(Runtime.SettingsManager.GetSetting("RecentProjects")) do
        Start.CreateProject(Scroll,v,i,Start.FullContainer)
    end

end

return Start