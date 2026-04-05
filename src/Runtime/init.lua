local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")

function Runtime.Init()
    Runtime.Renderer.Init()
    Runtime.Things.Init()
end

return Runtime