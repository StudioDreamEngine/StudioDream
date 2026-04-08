-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Renderer, Input handling, etc
local Backend = {}

function Backend.Get2DBackend()
    return require("Runtime.Backend.LoveBackend")
end

function Backend.Get3DBackend()
    return require("Runtime.Backend.Backend3D")
end

function Backend.Init()
    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
    Runtime.Backend3D.Update(dt)
end

return Backend