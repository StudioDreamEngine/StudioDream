-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Script Handler, Input handling, etc
local Backend = {}

function Backend.Init()
    Runtime.Services = require("Runtime.Backend.Services")
    
    Runtime.SelectionPriority = require("Runtime.Backend.SelectionPriority")
    Runtime.SelectionPriority.Init()

    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()

    Runtime.ScriptUtil = require("Runtime.Backend.ScriptUtility")

    ---@class MouseService
    Runtime.Cursor = Runtime.Services.Service("MouseService") -- For now, lazy

    Runtime.BaseFS = require("Runtime.Backend.BaseFS")
    Runtime.ProjectFS = require("Runtime.Backend.ProjectFS")

    Runtime.Phys = require("Runtime.Backend.PhysicsEngine")
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
    Runtime.Services.Update(dt)
end

return Backend