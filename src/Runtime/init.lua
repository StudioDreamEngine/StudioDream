local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Resources = require("Runtime.Resources")
Runtime.Renderer = require("Runtime.Renderer")

Runtime.LoadProjectCallback = function() end

function Runtime.Init()
    Profiler.Init()
    Platform.Init("StudioDream")

    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Resources.Init()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    Runtime.ChangeAppIcon("/Assets/Icons/"..Shared.Target..".png")

    print("Runtime Initalized")
end

function Runtime.ChangeTitle()
    love.window.setTitle(string.format("StudioDream %s - %s (%s)", VERSION_FULL, Runtime.Project.GetConfig("Name"), Shared.Target))
end

function Runtime.ChangeAppIcon(ToWhat)
    local Thing = love.image.newImageData(ToWhat)
    love.window.setIcon(Thing)
end

function Runtime.RequestRestart(NextTarget)
    local Benchmark = Profiler.Benchmark("Restart StudioDream", true)

    Dream:requestKill(function()
        Benchmark.End()
        love.event.restart(NextTarget)
    end)
end

function Runtime.PostInit(ProjectPath)
    Runtime.Backend = require("Runtime.Backend")
    Runtime.Backend.Init()

    Runtime.SettingsManager = require("Runtime.SettingsManager")
    Runtime.SettingsManager.Init()

    Runtime.Things.CreateApiDump()

    Dream:prepareRuntime()

    Runtime.Project = require("Runtime.Project")
    Runtime.Things.CreateEnviornment()

    if Shared.Target == "Client" then
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

    --require("Runtime.Things.CreateTests")()
    Runtime.Project.LoadDefault()
end

function Runtime.Render()
    Runtime.Renderer.Render()

    Dream:presentDebug()
end

function Runtime.Update(dt)
    if Runtime.Backend then
        Runtime.Backend.Update(dt)
    end
    
    Runtime.Renderer.ViewportManager.Update(dt) -- temporary
    Runtime.Things.Update(dt)
end

function Runtime.OnCrash()
    Runtime.Project.Save()
end

return Runtime