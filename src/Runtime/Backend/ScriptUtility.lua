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

local AllowedExecutableTypes = {"exe"}

function ScriptUtil.ConfigureAndValidateEditor(EditorPath)
    if (not EditorPath) then
        EditorPath = Platform.OpenFileDialog("Configure Editor")
    end

    local InvalidFileType = true

    if type(EditorPath) == "string" then
        EditorPath = Path.new(EditorPath)
        InvalidFileType = EditorPath.FileType and (not table.find(AllowedExecutableTypes, EditorPath.FileType))
    end

    if InvalidFileType then
        Studio.Components.SimpleDialog("EditorPath was invalid, try opening the script again and re-configuring your editor.")
        return
    end

    Studio.SettingsManager.ChangeSetting("CodeEditor", EditorPath.FilePath)
    return EditorPath.FilePath
end

---@param ScriptObject BaseScript
function ScriptUtil.HandleOpenScript(ScriptObject)
    -- Create new resource for object if none is found
    if (not ScriptObject.Resource) then
        local Identifier, _ = Runtime.Resources.LoadIdentifier(ScriptObject.Name, "lua")
        ScriptObject:SetResource(Identifier)
    end

    -- Configure editor if needed
    local ConfiguredEditor = Studio.SettingsManager.GetSetting("CodeEditor")
    ConfiguredEditor = ScriptUtil.ConfigureAndValidateEditor(ConfiguredEditor)

    -- Open the script
    if ConfiguredEditor then
        Platform.Execute(ConfiguredEditor, Runtime.BackendFS.GetFullPath(ScriptObject.Resource))
    end
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