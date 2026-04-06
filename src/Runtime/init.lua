local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")
Runtime.Backend2D = require("Runtime.LoveBackend")

function Runtime.Init()
    Runtime.Renderer.Init()
    Runtime.Things.Init()
end

return Runtime