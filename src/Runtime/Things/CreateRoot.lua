local Things = Runtime.Things

-- Create our DataModel/Root here
return function()
    ---@class Root
    local Root = Things.Create("Root", "Root") {
        Name = "Root"
    }

    ---@module 'Environment'
    local Environment = Things.Create("Environment") {
        Name = "Environment",
        Parent = Root
    }

    local HUD = Things.Create("HUD") {
        Name = "HUD",
        Parent = Root
    }

    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Size = Pivot2D.FromOffset(800, 600),
        Serializable = false,
        Parent = Root
    }

    --[[local EnvViewport = Things.Create("Viewport3D") {
        Size = Pivot2D.FromScale(0.75,0.8),
        Position = Pivot2D.FromScale(0,0),
        Parent = Viewport,
        RenderFolder = Environment,
        Name = "MainViewport"
    }]]

    ---@module 'Camera'
    local Camera = Things.Create("Camera") {
        Name = 'Camera',
        Parent = Environment
    }

    Environment.Camera = Camera

    Root.RootViewport = Viewport

    -- All test-related root stuff is moved to CreateTests.lua

    return Root
end