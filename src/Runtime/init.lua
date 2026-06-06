local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Resources = require("Runtime.Resources")
Runtime.Renderer = require("Runtime.Renderer")

function Runtime.Init()
    Profiler.Init()

    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    print("Runtime Initalized")
end

function Runtime.PostInit()
    Runtime.Backend = require("Runtime.Backend")
    Runtime.Backend.Init()

    Runtime.Things.CreateEnviornment()
    Runtime.Things.CreateApiDump()

    Runtime.Resources.Init()

    Runtime.Project = require("Runtime.Project")

    require("Runtime.Things.CreateTests")()
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