-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Script Handler, Input handling, etc
local Backend = {}

function Backend.Init()
    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()

    Runtime.ScriptUtil = require("Runtime.Backend.ScriptUtility")
    Runtime.ObjectProxy = require("Runtime.Backend.ObjectProxy")

    Runtime.Services = {}
    Runtime.Services.InputService = require("Runtime.Backend.Services.InputService")
    Runtime.Services.InputService:Init()
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
end

function love.keypressed(Key)
    Runtime.Services.InputService:keypressed(Key)
end

function love.keyreleased(Key)
    Runtime.Services.InputService:keyreleased(Key)
end

return Backend