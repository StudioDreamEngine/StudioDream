local Things = Runtime.Things
Client = {}

local StudioCamera

function Client.Init()
    local EnvironmentViewport = Things.Create("Viewport3D") {
        Parent = Things.GetRootViewport(),
        RenderFolder = Things.GetRoot("Environment"),
        Size = Pivot2D.FromScale(1,1),
    }

    local HudViewport = Things.Create("Viewport2D") {
        RenderFolder = Things.GetRoot("HUD"),
        Name = "HudViewport",
        Size = Pivot2D.FromScale(1,1),
        Layer = 2,
        Parent = Things.GetRootViewport()
    }

    Things.Root.EnvironmentViewport = EnvironmentViewport

    StudioCamera = require("Client.StudioCamera")
    StudioCamera.Init()

    print(Things.GetRoot("Environment"):GetDescendants())
    Runtime.ScriptUtil.StartScripts()

    local Environment = Runtime.Things.Root:GetEnvironment()
    Environment.StepPhysics = true
end

function Client.Update(dt)
    StudioCamera.Update(dt)
end

function Client.Render()
    
end

return Client