local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")
Runtime.Backend = require("Runtime.Backend")

function Runtime.Init()
    Profiler.Init()

    Runtime.Backend.Init()

    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    Runtime.Backend.PostInit()

    Runtime.Serializer = require("Runtime.Serialization")

    --Shared.

    print("Runtime Initalized")
end

function Runtime.Render()
    Runtime.Renderer.Render()

    Dream:presentDebug()
end

function Runtime.Update(dt)
    Profiler.Start("StudioDream - Update")

        Shared.UpdateRuntime(dt)
        Runtime.Backend.Update(dt)
        Runtime.Renderer.ViewportManager.Update(dt) -- temporary
        Runtime.Things.Update(dt)

    Profiler.End()
end

return Runtime