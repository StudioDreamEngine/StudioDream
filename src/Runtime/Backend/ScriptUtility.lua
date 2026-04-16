local ScriptUtil = {}

local function ProxyIndex(Instance, Key)
    if (not Instance[Key]) then
        -- Assume child
        local Child = Instance:FindFirstChild(Key)

        return Child and ScriptUtil.InstanceProxy(Child) or nil
    else
        return Instance[Key]
    end
end

local function ProxyNewIndex(Instance, Key, Value)
    local HasSetter = Instance["Set"..Key]

    if HasSetter then
        HasSetter(Instance, Value)
    else
        Instance[Key] = Value
    end
end

function ScriptUtil.InstanceProxy(Instance)
    return setmetatable({
        UUID = Instance.UUID -- Maybe this will work for an == replacement? either way Thing:Is() will still exist
    }, {
        __index = function(_, k) return ProxyIndex(Instance, k) end,
        __newindex = function(_,k,v) ProxyNewIndex(Instance, k, v) end
    })
end

function ScriptUtil.CreateGlobals(Script)
    return {
        script = Script,
        wait = Scheduler.Yield,
        print = print,
        require = function(Object)
            return Object:Load()
        end
    }
end

return ScriptUtil