local Things = Runtime.Things
local CreateRoot = {}

function CreateRoot.CreateEnviornment(Root)
    local HUD = Things.Create("HUD") {
        Name = "HUD",
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

    local Assets = Things.Create("Environment") {
        Name = "Environment",
        Parent = Root
    }
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