-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Script Handler, Input handling, etc
local Backend = {}

function Backend.Init()
    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()

    Runtime.ScriptUtil = require("Runtime.Backend.ScriptUtility")
    Runtime.ObjectProxy = require("Runtime.Backend.ObjectProxy")
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
end

return Backend