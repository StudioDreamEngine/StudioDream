-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Script Handler, Input handling, etc
local Backend = {}

function Backend.Init()
    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()

    Runtime.ScriptUtil = require("Runtime.Backend.ScriptUtility")

    Runtime.Services = require("Runtime.Backend.Services")
    Runtime.Cursor = require("Runtime.Backend.CursorHandle")

    Runtime.BackendFS = require("Runtime.Backend.BackendFS")

    Runtime.Phys = require("Runtime.Backend.PhysicsEngine")

    Runtime.SelectionPriority = require("Runtime.Backend.SelectionPriority")
    Runtime.SelectionPriority.Init()
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
    Runtime.Services.Update(dt)
end

return Backend