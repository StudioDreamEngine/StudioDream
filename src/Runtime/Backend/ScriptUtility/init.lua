-- General script utils for studio and runtime
local ScriptUtil = {}
local Things = Runtime.Things

local LoadQueued = {}
local StartedScripts = false

local Bridge = require("Runtime.Backend.ScriptUtility.Bridge")

ScriptUtil.BridgeProxy = Bridge.Proxy

-- Queue a script for loading, as we may not want to start scripts immediately
---@param Script BaseScript
function ScriptUtil.RequestLoad(Script)
    if StartedScripts then Script:Load() return end

    printVerbose("Queued Script for loading")
    table.insert(LoadQueued, Script) 
end

function ScriptUtil.StartScripts()
    StartedScripts = true

    ---@param Queued BaseScript
    for _, Queued in pairs(LoadQueued) do Queued:Load() end
    LoadQueued = {}
end

function ScriptUtil.CreateGlobals(Script)
    return {
        Script = ScriptUtil.BridgeProxy(Script),
        Scheduler = Scheduler,
        print = print,
        Root = ScriptUtil.BridgeProxy(Things.Root),
        Service = Runtime.Services.Service,
        math = math,
        pairs = pairs,
        CreateThing = Runtime.Things.Create,
        time = function()
            return GlobalTick
        end,

        Transform3D = Transform3D,
        Transform2D = Transform2D,
        Vector2 = Vector2,
        Vector3 = Vector3,
        Enum = Enum,
        Rect = Rect,
        
        ---@param Object RequirableScript
        require = function(Object)
            if Object:IsA("RequirableScript") then
                return Object:Require()
            end
        end
    }
end

return ScriptUtil