local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")
Runtime.Backend = require("Runtime.Backend")

function Runtime.Init()
    Runtime.Backend.Init()
    Runtime.Backend2D = Runtime.Backend.Get2DBackend()

    Runtime.Renderer.Init()
    Runtime.Things.Init()
end

function Runtime.Update(dt)
    Runtime.Backend.Update(dt)
    Runtime.Things.Update(dt)
end

return Runtime