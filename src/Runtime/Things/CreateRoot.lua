local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        Root = true
    }

    local ImageTest2 = Things.Create("Text") {
        Text = "WW",
        Name = "ImageTest2",
        Position = Pivot2D.FromScale(0.2,0.6),
        Size = Pivot2D.FromScale(0.3,0.3),
        Parent = Viewport
    }

    local ExplorerViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.FromScale(0.25,0.8),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Parent = Viewport,
        Name = "ExplorerViewport"
    }

    local MainViewport = Things.Create("Viewport3D") {
        Size = Pivot2D.FromScale(0.75,0.5),
        Position = Pivot2D.FromScale(0,0),
        Parent = Viewport,
        Name = "MainViewport"
    }

    require("Runtime.Things.StudioUI.ExplorerRender")(Viewport, ExplorerViewport)
    require("Runtime.Things.StudioUI.TopBar")(Viewport, ExplorerViewport)

    return { Viewport = Viewport }
end