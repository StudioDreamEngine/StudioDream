local Things = Runtime.Things
local CreateRoot = {}

function CreateRoot.CreateEnviornment(Root)
    ---@class Environment
    local Environment = Things.Create("Environment", "Environment") {
        Name = "Environment",
        Parent = Root
    }
end

function CreateRoot.CreateRoot()
    ---@class Root
    local Root = Things.Create("Root", "Root") {
        Name = "Root"
    }

    local HUD = Things.Create("HUD", "Gui") {
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
    Runtime.Renderer.ViewportManager.SetRootViewport(Viewport) -- Indexing kills me but whatever

    return Root
end

return CreateRoot