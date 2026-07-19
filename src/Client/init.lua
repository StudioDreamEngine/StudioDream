local Things = Runtime.Things
Client = {}

--local StudioCamera

function Client.Init()
    local EnvironmentViewport = Things.Create("Viewport3D") {
        Parent = Things.GetRootViewport(),
        RenderContainer = Things.GetRoot("Environment"),
        Size = Pivot2D.FromScale(1,1),
    }

    local HudViewport = Things.Create("Viewport2D") {
        RenderContainer = Things.GetRoot("HUD"),
        Name = "HudViewport",
        Size = Pivot2D.FromScale(1,1),
        Layer = 2,
        Parent = Things.GetRootViewport()
    }

    Things.Root.EnvironmentViewport = EnvironmentViewport
    print("BBBBBBBBBBBBBBBBBBBBBBBB")
    if Runtime.Project.Config.Get("Icon") then
        local ResourceLoaded = Runtime.Resources.LoadResourceFromIdentifier(Runtime.Project.Config.Get("Icon"))
        local ActuallyImageData = Utils.TextureToImageData(ResourceLoaded)
        local Thing = ActuallyImageData
        love.window.setIcon(Thing)
    else
        local Thing = love.image.newImageData("/Assets/Icons/Client.png")
        love.window.setIcon(Thing)
    end

    Utils.SetWindowSize(Runtime.Project.Config.Get("WindowSize") or Vector2.new(1570,800))

    --StudioCamera = require("Client.StudioCamera")
    --StudioCamera.Init()

    print(Things.GetRoot("Environment"):GetDescendants())
    Runtime.ScriptUtil.StartScripts()

    local Environment = Runtime.Things.Root:GetEnvironment()
    Environment.StepPhysics = true

    Runtime.Things.Create("TextButton") {
        Parent = Runtime.Things.GetRootViewport(),
        Size = Pivot2D.FromScale(0.1,0.1),
        Layer = 1000,
        Text = "Placeholder Client to studio!!!",
        Clicked = function()
            Runtime.RequestRestart("Studio")
        end
    }
end

function Client.Update(dt)
    --StudioCamera.Update(dt)
end

function Client.Render()
    
end

return Client