---@class StudioScriptHandler
local ScriptHandler = {}

local AllowedExecutableTypes = {"exe"}
local ConfiguredEditor

function ScriptHandler.ConfigureEditor()
    local Dialog = Studio.Components.SimpleDialog("You currently do not have a configured editor, press ok to assign one.", function()
        Platform.OpenWithCallback(
            "Configure an Editor", 
            Enum.OpenDialog.File,
            ScriptHandler.ValidateEditor
        )
    end)

    Dialog.OnClose:Wait()
end

function ScriptHandler.ConfigureOrValidateEditor()
    ConfiguredEditor = Runtime.SettingsManager.Get("CodeEditor") -- Re-sync setting
    print(ConfiguredEditor)

    if (not ConfiguredEditor) then -- If we do not find an editor at all, configure a new one
        ScriptHandler.ConfigureEditor()
    else -- Otherwise, validate the existing one
        ScriptHandler.ValidateEditor(ConfiguredEditor)
    end

    Runtime.SettingsManager.Set("CodeEditor", ConfiguredEditor)
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
    if Runtime.SettingsManager.Get("AutomaticCreation") then
        return Runtime.Resources.CreateIdentifier(ScriptObject.Name..".lua")
    else
        local _, Path = Platform.OpenWithCallback("Open a script", Enum.OpenDialog.File, function() end)
        if (not Path) then return end

        local Identifier, _ = Runtime.Resources.LoadIdentifierIDFromPath(Path)
        if (not Identifier) then return end

        return Identifier, nil -- man
    end
end

---@param ScriptObject BaseScript
function ScriptHandler.HandleOpenScript(ScriptObject)
    if (not Runtime.SettingsManager.Get("FlagCreation")) then
        local Dialog = Studio.Components.CreateDialog(Enum.StudioDialog.Option, {
            Text = "Choose how you want to deal with opening scripts with no assigned resource",
            Choices = {
                {
                    Text = "Select a resource",
                    OnClick = function()
                        Runtime.SettingsManager.Set("AutomaticCreation", false)
                    end
                },
                {
                    Text = "Create automatically",
                    OnClick = function()
                        Runtime.SettingsManager.Set("AutomaticCreation", true)
                    end
                }
            }
        })

        Dialog.OnClose:Wait()
        Runtime.SettingsManager.Set("FlagCreation", true)
    end

    -- Create new resource for object if none is found
    if (not ScriptObject.Resource) then
        local Identifier, _ = ScriptHandler.CreateOrSelect(ScriptObject)

        if (not Identifier) then
            Studio.Components.SimpleDialog("Could not create or set the resource, Either something went wrong, or you didnt give one")
            return
        end

        ScriptObject:SetResource(Identifier)
        assert(ScriptObject.Resource, "No resource set (for some reason, seriously did you forget to set one? or did we do something stupid)")
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
    else
        print("Did not configure editor")
    end
end

return ScriptHandler