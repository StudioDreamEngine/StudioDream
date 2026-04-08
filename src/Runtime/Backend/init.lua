-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Renderer, Input handling, etc
local Backend = {}

Backend.InterfaceManager = require("Runtime.Backend.InterfaceManager")

function Backend.Get2DBackend()
    return require("Runtime.Backend.LoveBackend")
end

function Backend.Init()
    
end

function Backend.Update(dt)
    Backend.InterfaceManager.Update(dt)
end

return Backend