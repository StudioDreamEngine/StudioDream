local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Resources = require("Runtime.Resources")
Runtime.Renderer = require("Runtime.Renderer")
Runtime.FromRestart = love.restart and true

function Runtime.Init()
    Profiler.Init()

    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    print("Runtime Initalized")
end

function Runtime.RequestRestart(NextTarget)
    local Benchmark = Profiler.Benchmark("Restart StudioDream", true)

    Runtime.Project.Save()

    Dream:requestKill(function()
        Benchmark.End()
        love.event.restart(NextTarget)
    end)
end

function Runtime.PostInit()
    Runtime.Backend = require("Runtime.Backend")
    Runtime.Backend.Init()

    Runtime.Things.CreateEnviornment()
    Runtime.Things.CreateApiDump()

    Runtime.Resources.Init()

    Runtime.Project = require("Runtime.Project")

    Runtime.Things.Create("TextButton") {
        Parent = Runtime.Things.GetRootViewport(),
        Size = Pivot2D.FromScale(0.2,0.2),
        Layer = 1000,
        Text = "Attempt target change",
        Clicked = function()
            Runtime.RequestRestart("Client")
        end
    }

    --require("Runtime.Things.CreateTests")()
    Runtime.Project.Load("../tests/ProjectTest/")
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

return Runtime