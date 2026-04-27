-- Handles the layout of windows themself
local Things = Runtime.Things
local StudioLayout = {}

local Theme = require("Editor.UI.Theme")

function StudioLayout.CreateWindowContainer(Transform)
    local Windows = {}
    
    Windows.Container = Runtime.Things.Create("Square") { 
        Size = Transform.Size,
        Position = Transform.Position,
        Pivot = Transform.Pivot,
        BackgroundColor = Theme.WindowColor,
        Name = "Properties",
        Layer = 1,
        Parent = StudioLayout.Windows
    }
    
    Windows.BackWindow = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.95,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Theme.BackWindowColor,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.Container
    }

    return Windows.BackWindow
end

function StudioLayout.CreateWindow(WindowType, Transform)
    local WindowContainer = StudioLayout.CreateWindowContainer(Transform)

    local Window = require("Editor.UI.Windows."..WindowType)
    Window.Init(WindowContainer)
end

--[[
    How should we even handle layouts
    idk how this entire flow system should work at all
]]

function StudioLayout.CreateLayout()
    StudioLayout.TopBar = Things.Create("Square") {
        Parent = Things.Root.RootViewport,
        Size = Pivot2D.FromScale(1,0.15),
        BackgroundColor = Theme.WindowColor
    }

    StudioLayout.Windows = Things.Create("Square") {
        Parent = Things.Root.RootViewport,
        Pivot = Vector2.new(0,1),
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(1,0.85),
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindow("MiklExplorer", {
        Size = Pivot2D.FromScale(0.25,.9),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0)
    })

    StudioLayout.CreateWindow("Viewport", {
        Size = Pivot2D.FromScale(0.75,.9),
    })
end

return StudioLayout