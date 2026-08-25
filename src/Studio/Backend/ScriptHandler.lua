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
    ConfiguredEditor = Runtime.SettingsManager.GetSetting("CodeEditor") -- Re-sync setting
    print(ConfiguredEditor)

    if (not ConfiguredEditor) then -- If we do not find an editor at all, configure a new one
        ScriptHandler.ConfigureEditor()
    else -- Otherwise, validate the existing one
        ScriptHandler.ValidateEditor(ConfiguredEditor)
    end

    Runtime.SettingsManager.ChangeSetting("CodeEditor", ConfiguredEditor)
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

function ScriptHandler.CreateOrSelect(ScriptObject)
    if Runtime.SettingsManager.GetSetting("AutomaticCreation") then
        return Runtime.Resources.CreateIdentifier(ScriptObject.Name..".lua")
    else
        error("Not implemented")
        --return Runtime.Resources.LoadOrCreateIdentifier
    end
end

---@param ScriptObject BaseScript
function ScriptHandler.HandleOpenScript(ScriptObject)
    --[[if (not Runtime.SettingsManager.GetSetting("EverSetCreation")) then
        Studio.Components.CreateDialog(Enum.StudioDialog.Option, {
            Text = "Do you want to always select a resource to use, or have StudioDream create it? (WIP)\nWe will only ask this once, you can change your mind in settings",
            Choices = {
                {
                    Text = "Select a resource",
                    OnClick = function()
                        
                    end
                },
                {
                    Text = "Create automatically",
                    OnClick = function()
                        
                    end
                }
            }
        })

        return
    end]]

    -- Create new resource for object if none is found
    if (not ScriptObject.Resource) then
        local Identifier, _ = ScriptHandler.CreateOrSelect(ScriptObject)
        ScriptObject:SetResource(Identifier)

        assert(ScriptObject.Resource, "No resource set (for some reason)")
    end

    -- Configure editor if needed
    ScriptHandler.ConfigureOrValidateEditor()

    -- Open the script
    if ConfiguredEditor then
        printVerbose(ConfiguredEditor)

        if string.find(ConfiguredEditor, " ") then
            ConfiguredEditor = "\""..ConfiguredEditor.."\""
        end

        local Data = ScriptObject.Resource.Data

        if ScriptObject.Resource.ResourceType == "Project" then
            Platform.Execute(ConfiguredEditor, "\""..Runtime.ProjectFS.GetFullPath(Data.FilePath).."\"")
        end
    end
end

return ScriptHandler