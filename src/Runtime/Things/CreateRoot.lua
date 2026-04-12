local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        Root = true
    }

    ---@module "TextButton"
    local ButtonTest = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(0.15,0.15),
        Position = Pivot2D.FromScale(0,1),
        Pivot = Vector2.new(0,1),
        Parent = Viewport,
        Name = "ButtonTest"
    }
    
    ButtonTest.Clicked:Connect(function()
        print("Button Click")
    end)

    local ExplorerViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.FromScale(0.25,0.8),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        Parent = Viewport,
        Name = "ExplorerViewport"
    }

    local MainViewport = Things.Create("Viewport3D") {
        Size = Pivot2D.FromScale(0.75,0.8),
        Position = Pivot2D.FromScale(0,0),
        Parent = Viewport,
        Name = "MainViewport"
    }

    local Mesh = Things.Create("Mesh") {
        Name = "Bleh"
    }
    Mesh:SetParent(MainViewport)

    require("Runtime.Things.StudioUI.ExplorerRender")(Viewport, ExplorerViewport)
    require("Runtime.Things.StudioUI.TopBar")(Viewport, ExplorerViewport)
    require("Runtime.Things.StudioUI.PropertiesRender")(Viewport, ExplorerViewport)
    return { Viewport = Viewport }
end