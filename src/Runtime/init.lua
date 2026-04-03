local Runtime = {}

Runtime.Types = require("Runtime.Types")
Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")

function Runtime.Init()
    
end

function Runtime.Update(dt)
    Runtime.Things.Update(dt)
end

return Runtime