local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")
Runtime.Backend = require("Runtime.Backend")

function Runtime.Init()
    Runtime.Backend.Init()

    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    Runtime.Render = Runtime.Renderer.Render
end

function Runtime.Update(dt)
    Runtime.Backend.Update(dt)
    Runtime.Renderer.ViewportManager.Update(dt) -- temporary
    Runtime.Things.Update(dt)
end

return Runtime