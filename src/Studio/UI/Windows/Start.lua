local Start = {}
local Things = Runtime.Things

local SecondsPerMinute = 60
local SecondsPerHour = SecondsPerMinute * 60
local SecondsPerDay = SecondsPerHour * 24

local AlreadyDidCloseButton = false

local DoneLoad = Signal:New("DoneLoadProjects")

local function TimeAgo(Time)
    local Difference = os.time()-Time

    if Difference > SecondsPerDay then
        return math.round(Difference/SecondsPerDay).." Days Ago"   
    elseif Difference > SecondsPerHour then
        return math.round(Difference/SecondsPerHour).." Hours Ago"   
    elseif Difference > SecondsPerMinute then
        return math.round(Difference/SecondsPerMinute).." Minutes Ago"  
    else
        return Difference.." Seconds ago"
    end
end

function CreateClose(Parent)
    if not AlreadyDidCloseButton then
        local Button = Studio.Components.CreateStyle("ImageButton",{
        Size = Pivot2D.FromScale(0.1,0.1),
        Parent = Parent,
        CornerRadius = 5,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        BackgroundTransparency = 0,
        BackgroundColor = Studio.CurrentTheme.Primary,
        Layer = 5,
        Resource = "Internal/Studio/Close.png",
        ScaleType = Enum.ScaleType.LockAspect,
        ForegroundColor = "Text",
        })
        Button.Clicked:Connect(Start.Close)
    end
    AlreadyDidCloseButton = true
end

function Start.CreateProject(Scroll,Info,Path,FullContainer)
    local Summary = Runtime.Project.GetSummary(Path)
    if (not Summary) then print(Path.." Returned no summary, assuming project is non-existant") return end

    local ImageToUse = Summary.ImageResource

    local Base = Studio.Components.CreateStyle("TextButton",{
        Text = "",
        Size = Pivot2D.FromScale(0.95,0.2),
        Parent = Scroll,
        Name = tostring(-Info.Time), -- dumb way to sort
        Layer = 2,
        CornerRadius = 5,
        BackgroundColor = Studio.CurrentTheme.Outline,
        --OutlineSize = 2,
        --OutlineColor = Studio.CurrentTheme.Outline,
    })

    local Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(.07,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = ImageToUse,
        Parent = Base,
        Pivot = Vector2.new(.5,.5),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    })

    local ProjectName = Studio.Components.CreateStyle("Text",{
        Text = Info.Name,
        ForegroundColor = "Text",
        Position = Pivot2D.FromScale(0,0),
        Parent = Base,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,0.5),
        Font = Studio.CurrentTheme.FontBold,
    })

    local Date = Studio.Components.CreateStyle("Text", {
        Text = "Last Mod: "..TimeAgo(Info.Time),
        ForegroundColor = "Text",
        Position = Pivot2D.FromScale(0,0.5),
        Parent = Base,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Size = Pivot2D.FromScale(1,0.5)
    })

    Base.Clicked:Connect(function()
        Runtime.Project.Load(Path)
        CreateClose(Start.Container)
        Start.Close()
        --Studio.Layout.CallHandle("Explorer", "Redraw")
    end)

    DoneLoad:Connect(function(LastNumber)
        if Base.LayoutOrder == 1 then
            local ProjectName = Studio.Components.CreateStyle("Text",{
                Text = "Most recent project",
                ForegroundColor = "Text",
                Position = Pivot2D.FromScale(0,0),
                --Pivot = Vector2.new(1,0),
                Parent = Base,
                Layer = 2,
                BackgroundTransparency = 1,
                Alignment = Vector2.new(1,0),
                Size = Pivot2D.FromScale(1,0.35),
                Font = Studio.CurrentTheme.FontBold,
            })
        end
    end)
end

function Start.CreateButton(Options,Text,Image)
    local selfed = {}

    local Base = Studio.Components.CreateStyle("TextButton",{
        Text = Text,
        Size = Pivot2D.FromScale(0.95,0.15),
        Parent = Options,
        Layer = 2,
        CornerRadius = 5,
        BackgroundColor = Studio.CurrentTheme.Outline,
        --OutlineSize = 2,
        Alignment = Vector2.new(1,0.5),
        TextSize = 5,
        --OutlineColor = Studio.CurrentTheme.Outline,
        ForegroundColor = "Text",
    })

    selfed.Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Position = Pivot2D.FromScale(.07,.5),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = Image,
        Parent = Base,
        Pivot = Vector2.new(.5,.5),
        CornerRadius = 5,
        --ScaleType = Enum.ScaleTypes.Fit
    })

    return Base
end

function Start.Close()
    Start.FullContainer:SetVisible(false)
    Studio.Components.HideFade()
end

function Start.Init()
    Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,0.5),
        Position = Pivot2D.FromScale(.5,.005),
        --SquareAxis = Enum.SquareAxis.X,
        Resource = "Internal/Studio/Update_Thumbs/Early_Riser.png",
        Parent = Start.Container,
        Pivot = Vector2.new(.5,0),
        CornerRadius = 5,
        ScaleType = Enum.ScaleType.Crop
    })

    local Version = Studio.Components.CreateStyle("Text", {
        Text = "Welcome to Early Riser! ("..VERSION..")",
        ForegroundColor = "Outline",
        Position = Pivot2D.FromScale(0.5,0),
        Size = Pivot2D.FromScale(1,0.1),
        Pivot = Vector2.new(0.5,0),
        Parent = Start.Container,
        Layer = 2,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5)
    })

    local Options = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.48,0.48),
        Parent = Start.Container,
        Layer = 2,
        CornerRadius = 5,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.25,.75),
        BackgroundColor = "Secondary",
       -- OutlineSize = 2,
        OutlineColor = Studio.CurrentTheme.Outline,
    })

    local RecentProjects = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.48,0.48),
        Parent = Start.Container,
        Layer = 2,
        CornerRadius = 5,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.75,.75),
        BackgroundColor = "Secondary",
       -- OutlineSize = 2,
        OutlineColor = Studio.CurrentTheme.Outline,
    })

    local Scroll = Studio.Components.CreateStyle("ScrollContainer",{
        Size = Pivot2D.FromScale(1,1),
        Parent = RecentProjects,
        BackgroundColor = Studio.CurrentTheme.Outline,
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = Scroll,
        Alignment = Enum.Alignment.TopCenter,
        Reverse = true,
        Padding = 3
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = Options,
        Alignment = Enum.Alignment.Center,
        Padding = 5
    })

    local NewProject = Start.CreateButton(Options,"Create new project.","Internal/Studio/AddThing.png")
    local LoadProject = Start.CreateButton(Options,"Load a project","Internal/Studio/TabIcons/InsertIcon.png")

    NewProject.Clicked:Connect(function()
        --Studio.ProjectManager.NewProject("Demo Project")
        local Cool = Studio.Components.CreateDialog("Input",{
            Text = "Input a name for your new project"
        })
        CreateClose(Start.Container)
        Start.Close()
        
        Cool.FinalProject:Connect(function(ProjectName)
            Studio.ProjectManager.NewProject(ProjectName)
            --Studio.Layout.CallHandle("Explorer", "Redraw")
        end)
    end)

    LoadProject.Clicked:Connect(function()
        CreateClose(Start.Container)
        Studio.ProjectManager.LoadProject(Start.Close)
        --Studio.Layout.CallHandle("Explorer", "Redraw")
    end)

    --local wow = Start.CreateButton(Options,"Close Window","Internal/Studio/Placeholders/Jeremy.png")
    --wow.Clicked:Connect(Start.Close)

    Version.Size = Pivot2D.FromScale(1,0.05)

    for i,v in pairs(Runtime.SettingsManager.GetSetting("Projects")) do
        Start.CreateProject(Scroll,v,i,Start.FullContainer)
    end
    DoneLoad.Invoke(table.length(Scroll:GetChildren()))
end

return Start