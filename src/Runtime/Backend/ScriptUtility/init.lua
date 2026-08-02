-- General script utils for studio and runtime
local ScriptUtil = {}
local Things = Runtime.Things

local LoadQueued = {}
local StartedScripts = false

local Bridge = require("Runtime.Backend.ScriptUtility.Bridge")

ScriptUtil.BridgeProxy = Bridge.Proxy

ScriptUtil.Shared={}

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

        Shared = ScriptUtil.Shared, -- im cryin

        string = string,
        table = table,
        tostring = tostring,
        tonumber = tonumber,
        print = print,
        math = math,
        pairs = pairs,
        time = function()
            return GlobalTick
        end,

        Root = ScriptUtil.BridgeProxy(Things.Root),
        Environment = ScriptUtil.BridgeProxy(Things.Root:GetEnvironment()),
        Lighting = ScriptUtil.BridgeProxy(Things.Root:GetChild("Lighting")),
        Assets = ScriptUtil.BridgeProxy(Things.Root:GetChild("Assets")),

        Service = Runtime.Services.Service,
        CreateThing = Runtime.Things.Create,

        Transform3D = Transform3D,
        Transform2D = Transform2D,
        Vector2 = Vector2,
        Vector3 = Vector3,
        Enum = Enum,
        Rect = Rect,
        Color = Color,
        loadstring = loadstring,

        ---@param Object RequirableScript
        require = function(Object)
            if Object:IsA("RequirableScript") then
                return Object:Require()
            end
        end
    }
end

return ScriptUtil