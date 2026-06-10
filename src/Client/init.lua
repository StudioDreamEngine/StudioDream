local Things = Runtime.Things
Client = {}

local StudioCamera

function Client.Init()
    local EnvironmentViewport = Things.Create("Viewport3D") {
        Parent = Things.GetRootViewport(),
        RenderFolder = Things.GetRoot("Environment"),
        Size = Pivot2D.FromScale(1,1),
    }

    Things.Root.EnvironmentViewport = EnvironmentViewport

    StudioCamera = require("Client.StudioCamera")
    StudioCamera.Init()

    print(Things.GetRoot("Environment"):GetDescendants())
    Runtime.ScriptManager.StartScripts()
end

function Client.Update(dt)
    StudioCamera.Update(dt)
end

function Client.Render()
    
end

return Client