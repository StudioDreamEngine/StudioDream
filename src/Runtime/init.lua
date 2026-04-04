local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")

function Runtime.Init()
    Runtime.Things.Init()
end

function Runtime.Update(dt)
    Runtime.Things.Update(dt)
end

return Runtime