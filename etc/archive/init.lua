---@diagnostic disable: undefined-global
local UI = {}

function UI.Init(Viewport)
    local Things = Runtime.Things

    local ExplorerViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.FromScale(0.25,0.8),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Parent = Viewport,
        Name = "ExplorerViewport"
    }

    --require("Editor.UI.PropertiesRender")(Viewport, ExplorerViewport)
end

function UI.CreateWindow(Size,Position,View)
    local Windows = {}
    
    Windows.Container = Runtime.Things.Create "Square" { 
        Size = Size,
        Position = Position,
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Editor.Theme.WindowColor,
        Name = "Properties",
        Layer = 1,
        Parent = View
    }
    
    Windows.BackWindow = Runtime.Things.Create "Square" {
        Size = Pivot2D.FromScale(0.9,0.9),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Editor.Theme.BackWindowColor,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.Container
    }

    return Windows
end

function UI.Update(dt)
    
end

return UI