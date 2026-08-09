local Things = Runtime.Things
local PConfig = {}

PConfig.Container = nil ---@class Square
PConfig.AllOptions = Utils.LoadModules("Studio/UI/Windows/ProjectConfigOptions/", true)
PConfig.CreatedButtons = {}

function PConfig.CreateMainSquares()
    local SquareObjects = {}

    SquareObjects.BaseOptions = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.3,0.95),
        Parent = PConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(.02,0.02),
        BackgroundColor = "Primary",
    })

    SquareObjects.Close = Studio.Components.CreateStyle("ImageButton",{
        Size = Pivot2D.FromScale(0.1,0.1),
        Parent = PConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        BackgroundTransparency = 0,
        Layer = 2,
        Resource = "Internal/Studio/Close.png",
        ScaleType = Enum.ScaleType.LockAspect,
        ForegroundColor = "Text",
        BackgroundColor = "Outline"
    })

    SquareObjects.Options = Studio.Components.CreateStyle("ScrollContainer",{
        Size = Pivot2D.FromScale(1,1),
        Parent = SquareObjects.BaseOptions,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.5,.5),
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = SquareObjects.Options,
        Alignment = Enum.Alignment.Center,
        Padding = 10,
    })

    SquareObjects.RenderOption = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.65,0.95),
        Parent = PConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(.98,0.02),
        BackgroundColor = "Primary",
    })

    SquareObjects.Close.Clicked:Connect(function()
        PConfig.FullContainer:SetVisible(false)
    end)

    return SquareObjects
end

function PConfig.ToggleOption(Name)
    for _,OObj in pairs(PConfig.CreatedButtons) do
        OObj.Module.Toggle(false)
    end
    PConfig.CreatedButtons[Name].Module.Toggle(true)
end

function PConfig.CreateOption(Module,Parent,Name)
    local OptionObject = {}

    OptionObject.Main = Studio.Components.CreateStyle("TextButton",{
        Size = Pivot2D.FromScale(0.95,0.05),
        Parent = Parent,
        CornerRadius = 5,
        BackgroundColor = "Outline",
        ForegroundColor = "Text",
        Text = Module.DisplayName
    })

    OptionObject.Main.Clicked:Connect(function()
        PConfig.ToggleOption(Name)
    end)

    return OptionObject
end

function PConfig.Init()
    Studio.Components.RegisterToTheme(PConfig.Container, "BackgroundColor", "Outline")
    local Created = PConfig.CreateMainSquares()
    printVerbose(PConfig.AllOptions)
    for Name,Module in pairs(PConfig.AllOptions) do
        local OptionObject = {
            Button = PConfig.CreateOption(Module,Created.Options,Name),
            Module = Module.Create(Created.RenderOption)
        }
        PConfig.CreatedButtons[Name] = OptionObject
    end
    for _,OObj in pairs(PConfig.CreatedButtons) do
        OObj.Module.Toggle(false)
    end
end

function PConfig.Update(dt)
    
end

return PConfig