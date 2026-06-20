---@class StudioScriptHandler
local ScriptHandler = {}

local AllowedExecutableTypes = {"exe"}
local ConfiguredEditor

function ScriptHandler.ConfigureEditor()
    Platform.OpenWithCallback(
        "Configure an Editor", 
        Enum.OpenDialog.File,
        ScriptHandler.ValidateEditor
    )
end

function ScriptHandler.ConfigureOrValidateEditor()
    ConfiguredEditor = Studio.SettingsManager.GetSetting("CodeEditor") -- Re-sync setting
    print(ConfiguredEditor)

    if (not ConfiguredEditor) then -- If we do not find an editor at all, configure a new one
        ScriptHandler.ConfigureEditor()
    else -- Otherwise, validate the existing one
        ScriptHandler.ValidateEditor(ConfiguredEditor)
    end

    Studio.SettingsManager.ChangeSetting("CodeEditor", ConfiguredEditor)
end

function ScriptHandler.ValidateEditor(EditorPath)
    local InvalidFileType = true

    if type(EditorPath) == "string" then
        EditorPath = Path.new(EditorPath)
        print(EditorPath)

        InvalidFileType = EditorPath.FileType and (not table.find(AllowedExecutableTypes, EditorPath.FileType)) or false
    end

    if InvalidFileType then
        ConfiguredEditor = nil
        Studio.Components.SimpleDialog("EditorPath was invalid! Press ok to assign a new editor.", ScriptHandler.ConfigureEditor)
    else
        ConfiguredEditor = EditorPath.FilePath
    end
end

---@param ScriptObject BaseScript
function ScriptHandler.HandleOpenScript(ScriptObject)
    -- Create new resource for object if none is found
    if (not ScriptObject.Resource) then
        local Identifier, _ = Runtime.Resources.LoadOrCreateIdentifier(ScriptObject.Name..".lua")
        ScriptObject:SetResource(Identifier)
    end

    -- Configure editor if needed
    ScriptHandler.ConfigureOrValidateEditor()

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