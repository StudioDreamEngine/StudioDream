---@class StudioScriptHandler
local ScriptHandler = {}

local AllowedExecutableTypes = {"exe"}

function ScriptHandler.ConfigureAndValidateEditor(EditorPath)
    if (not EditorPath) then
        EditorPath = Platform.OpenFileDialog("Configure Editor")
    end

    local InvalidFileType = true

    if type(EditorPath) == "string" then
        EditorPath = Path.new(EditorPath)
        print(EditorPath)

        InvalidFileType = EditorPath.FileType and (not table.find(AllowedExecutableTypes, EditorPath.FileType)) or false
    end

    if InvalidFileType then
        Studio.Components.SimpleDialog("EditorPath was invalid! Press ok to assign a new editor.")
        return ScriptHandler.ConfigureAndValidateEditor()
    end

    Studio.SettingsManager.ChangeSetting("CodeEditor", EditorPath.FilePath)
    return EditorPath.FilePath
end

---@param ScriptObject BaseScript
function ScriptHandler.HandleOpenScript(ScriptObject)
    -- Create new resource for object if none is found
    if (not ScriptObject.Resource) then
        local Identifier, _ = Runtime.Resources.LoadOrCreateIdentifier(ScriptObject.Name..".lua")
        ScriptObject:SetResource(Identifier)
    end

    -- Configure editor if needed
    local ConfiguredEditor = Studio.SettingsManager.GetSetting("CodeEditor")
    ConfiguredEditor = ScriptHandler.ConfigureAndValidateEditor(ConfiguredEditor)

    -- Open the script
    if ConfiguredEditor then
        print(ConfiguredEditor)

        if string.find(ConfiguredEditor, " ") then
            ConfiguredEditor = "\""..ConfiguredEditor.."\""
        end

        Platform.Execute(ConfiguredEditor, Runtime.BackendFS.GetFullPath(ScriptObject.Resource))
    end
end

return ScriptHandler