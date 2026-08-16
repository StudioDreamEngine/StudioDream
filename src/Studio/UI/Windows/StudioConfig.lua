local Things = Runtime.Things
local StudioConfig = {}

StudioConfig.Container = nil ---@class Square
StudioConfig.AllOptions = Utils.LoadModules("Studio/UI/Windows/StudioConfigOptions/", true)
StudioConfig.CreatedButtons = {}

function StudioConfig.CreateMainSquares()
    local SquareObjects = {}
    
    SquareObjects.BaseOptions = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.3,0.95),
        Parent = StudioConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(.02,0.02),
        BackgroundColor = "Primary",
    })

    SquareObjects.Close = Studio.Components.CreateStyle("ImageButton",{
        Size = Pivot2D.FromScale(0.1,0.1),
        Parent = StudioConfig.Container,
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
        Parent = StudioConfig.Container,
        CornerRadius = 5,
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(.98,0.02),
        BackgroundColor = "Primary",
    })

    SquareObjects.Close.Clicked:Connect(function()
        StudioConfig.FullContainer:SetVisible(false)
    end)

    return SquareObjects
end

function StudioConfig.ToggleOption(Name)
    for _,OObj in pairs(StudioConfig.CreatedButtons) do
        OObj.Container:SetVisible(false)
    end

    StudioConfig.CreatedButtons[Name].Container:SetVisible(true)
end

function StudioConfig.CreateOption(Module,Parent,Name)
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
        StudioConfig.ToggleOption(Name)
    end)

    return OptionObject
end

function StudioConfig.Init()
    Studio.Components.RegisterToTheme(StudioConfig.Container, "BackgroundColor", "Outline")

    local Created = StudioConfig.CreateMainSquares()
    printVerbose(StudioConfig.AllOptions)
    
    for Name,Module in pairs(StudioConfig.AllOptions) do
        local OptionContainer = Things.Create("Square") {
            Parent = Created.RenderOption,
            Size = Pivot2D.FromScale(1,1),
            BackgroundTransparency = 1
        }

        local OptionObject = {
            Button = StudioConfig.CreateOption(Module,Created.Options,Name),
            Module = Module.Create(OptionContainer),
            Container = OptionContainer
        }

        StudioConfig.CreatedButtons[Name] = OptionObject
    end

    for _,OObj in pairs(StudioConfig.CreatedButtons) do
        OObj.Container:SetVisible(false)
    end
end

function StudioConfig.Update(dt)
    
end

return StudioConfig