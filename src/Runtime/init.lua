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

return Runtime