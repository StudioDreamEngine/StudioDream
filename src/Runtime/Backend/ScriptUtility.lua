-- General script utils for studio and runtime
local ScriptUtil = {}
local Things = Runtime.Things

local function ProxyIndex(Instance, Key)
    if (not Instance[Key]) then
        -- Assume child
        local Child = Instance:FindFirstChild(Key)

        return Child and ScriptUtil.InstanceProxy(Child) or nil
    else
        return Instance[Key]
    end
end

---@param ScriptObject BaseScript
function ScriptUtil.HandleOpenScript(ScriptObject)
    if (not ScriptObject.Resource) then
        -- Create new resource for object
        local Identifier, _ = Runtime.Resources.RegisterIdentifierFromFile(ScriptObject.Name, "lua")
        ScriptObject:SetResource(Identifier)
    end

    local ConfiguredEditor = Studio.SettingsManager.GetSetting("CodeEditor")

    if (not ConfiguredEditor) then
        ConfiguredEditor = Platform.OpenFileDialog("Configure Editor")

        Studio.SettingsManager.ChangeSetting("CodeEditor", ConfiguredEditor)
    end

    Platform.Execute(ConfiguredEditor, Runtime.BackendFS.GetFullPath(ScriptObject.Resource))
end

function ScriptUtil.SetProperty(Object, Index, Value)
    local HasSetter = Object["Set"..Index]

    if HasSetter then
        HasSetter(Object, Value)
    else
        Object[Index] = Value
    end
end

function ScriptUtil.InstanceProxy(Instance)
    return setmetatable({
        UUID = Instance.UUID -- Maybe this will work for an == replacement? either way Thing:Is() will still exist
    }, {
        __index = function(_, k) return ProxyIndex(Instance, k) end,
        __newindex = function(_,k,v) Things.SetProperty(Instance,k, v) end
    })
end

function ScriptUtil.CreateGlobals(Script)
    return {
        script = Script,
        wait = Scheduler.Yield,
        print = print,

        ---@param Object Script
        require = function(Object)
            if Object:IsA("BaseScript") then
                return Object:Load()
            end
        end
    }
end

return ScriptUtil