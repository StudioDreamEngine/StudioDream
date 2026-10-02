local Things = Runtime.Things
local CreateRoot = {}

function CreateRoot.CreateRootTemplate(Root)
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

    Runtime.Things.Create("Sky") {
        Parent = Runtime.Things.Root:FindFirstChild("Lighting")
    }
end

function CreateRoot.CreateEnvTemplate()
    local Environment = Things.Create("Environment") {
        Name = "Environment"
    }

    local Camera = Runtime.Things.Create("Camera") {
        Parent = Environment
    }

    Runtime.Things.Create("Primitive") {
        Scale = Vector3.new(40,2,40),
        Position = Vector3.new(0,-10,0),
        Parent = Environment
    }

    Environment.Camera = Camera 
    return Environment
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

    ---@module 'ViewportLite'
    local Viewport = Things.Create("ViewportLite") {
        Name = "ViewportInternal",
        Parent = RenderRoot
    }

    Runtime.Renderer.ViewportManager.SetRootViewport(Viewport) -- Indexing kills me but whatever
    return Root, Viewport
end

return CreateRoot