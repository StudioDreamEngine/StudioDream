-- General script utils for studio and runtime
local ScriptUtil = {}
local Things = Runtime.Things

local LoadQueued = {}
local StartedScripts = false

local Bridge = require("Runtime.Backend.ScriptUtility.Bridge")

ScriptUtil.BridgeProxy = Bridge.Proxy

local function ProxyIndex(Instance, Key)
    if (not Instance[Key]) then
        -- Assume child
        local Child = Instance:FindFirstChild(Key)

        return Child and ScriptUtil.InstanceProxy(Child) or nil
    else
        return Instance[Key]
    end
end

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

---@param Instance Thing
function ScriptUtil.InstanceProxy(Instance)
    return setmetatable({
        UUID = Instance.UUID -- Maybe this will work for an == replacement? either way Thing:Is() will still exist
    }, {
        __index = function(_, k) return ProxyIndex(Instance, k) end,
        __newindex = function(_,k,v) 
            print(k,v)
            Things.SetProperty(Instance,k, v)
        end
    })
end

function ScriptUtil.CreateGlobals(Script)
    return {
        script = Script,
        scheduler = Scheduler,
        print = print,
        root = Things.Root,
        environment = Things.Root:GetEnvironment(),
        service = Runtime.Services.Service,
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