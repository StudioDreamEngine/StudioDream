local Things = Runtime.Things
local CreateRoot = {}

function CreateRoot.CreateEnviornment(Root)
    ---@class Environment
    local Environment = Things.Create("Environment") {
        Name = "Environment",
        Parent = Root
    }

    ---@module 'Camera'
    local Camera = Things.Create("Camera") {
        Name = 'Camera',
        Parent = Environment
    }

    Environment.Camera = Camera
end

function CreateRoot.CreateRoot()
    ---@class Root
    local Root = Things.Create("Root", "Root") {
        Name = "Root"
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

    Root.RootViewport = Viewport

    return Root
end

return CreateRoot