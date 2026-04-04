local Runtime = {}

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")

function Runtime.Init()
    require("Runtime.Types")
end

function Runtime.Update(dt)
    Runtime.Things.Update(dt)
end

return Runtime