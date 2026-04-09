-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Renderer, Input handling, etc
local Backend = {}

function Backend.Init()
    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
end

return Backend