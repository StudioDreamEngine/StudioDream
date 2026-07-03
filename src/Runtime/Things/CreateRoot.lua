local Things = Runtime.Things
local CreateRoot = {}

local HUD, Materials

function CreateRoot.CreateEnviornment(Root)
    ---@class Environment
    local Environment = Things.Create("Environment") {
        Name = "Environment",
        Parent = Root
    }

    Runtime.Project.RegisterRootScene(Environment, "MainScene")
    Runtime.Project.RegisterRootScene(HUD, "Interface")
    Runtime.Project.RegisterRootScene(Materials, "Materials")
end

function CreateRoot.CreateRoot()
    ---@class Root
    local Root = Things.Create("Root", "Root") {
        Name = "Root"
    }

    HUD = Things.Create("GuiContainer", "Gui") {
        Name = "HUD",
        Parent = Root
    }

    Materials = Things.Create("Materials", "Materials") {
        Name = "Materials",
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