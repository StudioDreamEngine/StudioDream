local Things = Runtime.Things
local PConfig = {}

PConfig.Container = nil ---@class Square
PConfig.AllOptions = Utils.LoadModules("Studio/UI/Windows/ProjectConfigOptions/", true)

function PConfig.CreateMainSquares()
    local SquareObjects = {}

    SquareObjects.BaseOptions = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.3,0.95),
        Parent = PConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(.02,0.02),
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
    }

    SquareObjects.Options = Runtime.Things.Create("ScrollContainer") {
        Size = Pivot2D.FromScale(1,1),
        Parent = SquareObjects.BaseOptions,
        Pivot = Vector2.new(.5,.5),
        Position = Pivot2D.FromScale(.5,.5),
    }

    Runtime.Things.Create("ListLayout") {
        Parent = SquareObjects.Options
    }

    SquareObjects.RenderOption = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.65,0.95),
        Parent = PConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(.98,0.02),
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
    }

    return SquareObjects
end

function PConfig.CreateOption(Module,Parent)
    print("Blehsssssssssssssssssssssssss")
    print(Module)
    Runtime.Things.Create("TextButton") {
        Size = Pivot2D.FromScale(1,0.1),
        Parent = Parent,
        CornerRadius = 5,
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        ForegroundColor = Studio.Theme.CurrentTheme.Text2,
        Text = Module.DisplayName
    }
end

function PConfig.Init()
    PConfig.Container.BackgroundColor = Studio.Theme.CurrentTheme.Outline
    local Created = PConfig.CreateMainSquares()

    for OptionMol,_ in pairs(PConfig.AllOptions) do
        PConfig.CreateOption(OptionMol,Created.Options)
    end
end

function PConfig.Update(dt)
    
end

return PConfig