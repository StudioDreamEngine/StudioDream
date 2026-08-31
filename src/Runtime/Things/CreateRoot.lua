local Things = Runtime.Things
local CreateRoot = {}

function CreateRoot.CreateEnviornment(Root)
    ---@class Environment
    local Environment = Things.Create("Environment") {
        Name = "Environment",
        Parent = Root
    }

    local HUD = Things.Create("HUD") {
        Name = "HUD",
        Parent = Root
    }

    local Materials = Things.Create("Materials") {
        Name = "Materials",
        Parent = Root
    }

    local Lighting = Things.Create("Lighting") {
        Name = "Lighting",
        Parent = Root
    }

    local Assets = Things.Create("Assets") {
        Name = "Assets",
        Parent = Root
    }

    Runtime.Project.RegisterRootScene(Environment, "MainScene")
    Runtime.Project.RegisterRootScene(HUD, "Interface")
    Runtime.Project.RegisterRootScene(Materials, "Materials")
    Runtime.Project.RegisterRootScene(Lighting, "Lighting")
    Runtime.Project.RegisterRootScene(Assets, "Assets")
end

function CreateRoot.CreateRoot()
    -- Tree used for the project itself, this is what user scripts see
    ---@class Root
    local Root = Things.Create("Root", "Root") {
        Name = "Root"
    }

    -- This is the internal tree used for the studio and client, blocked off from user scripts
    local RenderRoot = Things.Create("Root", "RenderRoot") { -- dumbass hack
        Name = "RenderRoot"
    }

    ---@module 'Viewport2D'
    local Viewport = Things.Create("Viewport2D") {
        Name = "ViewportInternal",
        Parent = RenderRoot
    }

    Runtime.Renderer.ViewportManager.SetRootViewport(Viewport) -- Indexing kills me but whatever
    return Root, Viewport
end

return CreateRoot