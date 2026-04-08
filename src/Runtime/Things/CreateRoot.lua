local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        Root = true
    }

    local ImageTest2 = Things.Create("Image2D") {
        Image = "Assets/EditorIcons/16/add.png",
        Name = "ImageTest2",
        Position = Pivot2D.FromScale(0.2,0.2),
        Parent = Viewport
    }

    local ExplorerViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.FromScale(0.3,1),
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,.5),
        Parent = Viewport,
        Name = "ExplorerViewport"
    }

    require("Runtime.Things.ExplorerRender")(Viewport, ExplorerViewport)

    return { Viewport = Viewport }
end