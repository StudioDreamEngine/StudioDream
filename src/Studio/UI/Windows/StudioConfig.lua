local Components = Studio.Components
local Input = Runtime.Services.Service("InputService") ---@class InputService

local StudioConfig = {}
StudioConfig.Container = nil ---@class Square

-- i dont like this
local function ReturnDisplay(Inputs)
    local First = Enum.InputCode.NameFromValue(Inputs.First)

    if Inputs.Second then
        local Second = Enum.InputCode.NameFromValue(Inputs.Second)

        return First.."+"..Second
    else
        return First
    end
end

-- Generate the options for the shortcut tab
function StudioConfig.GenerateShortcuts()
    local Options = {}

    for BindName, _ in pairs(Studio.ShortcutsHandler.GetKeys()) do
        local Inputs = Studio.ShortcutsHandler.GetInput(BindName)

        table.insert(Options, {
            Title = BindName,
            Type = "Button",
            ReturnDisplay = function() -- Called each time the updator is called, return a text-friendly version of `Value`
                return ReturnDisplay(Inputs)
            end,
            UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
                -- DONE by UserRequest, ignore!!
            end,
            UserRequest = function(OnFinished)
                Input.KeyEvent:ConnectOnce(function(_, Key)
                    -- Which key to change
                    local TargetKey = Inputs.Second and "Second" or "First"
                    Studio.ShortcutsHandler.SetInput(BindName, TargetKey, Key)

                    OnFinished()
                end)

                return "Waiting for input..."
            end,
            Choices = {}
        })
    end

    return Options
end

function StudioConfig.Init()
    Components.Settings.new({
        General = {
            {
                Title = "Theme",
                Type = "Dropdown",
                ReturnDisplay = function() -- Called each time the updator is called, return a text-friendly version of `Value`
                    return Studio.Theme.CurrentName
                end,
                UserChange = function(Text) -- Called every time the user changes the value, its your job to take `Text` and update the corresponding `Value`
                    Studio.Theme.ChangeTheme(Text)
                end,
                Choices = Studio.Theme.GetNames()
            },
            {
                Title = "Code Editor",
                Type = "Button",
                UserRequest = function(Change)
                    Platform.OpenWithCallback("Configure an Code Editor", Enum.OpenDialog.File,function(NewPath)
                        local Editor = Studio.ScriptHandler.ValidateEditor(NewPath)
                        Change(Editor)
                    end)
                end,
                UserChange = function(InfoGiven)
                    Runtime.SettingsManager.Set("CodeEditor", InfoGiven)
                end,
                ReturnDisplay = function()
                    return Path.new(Runtime.SettingsManager.Get("CodeEditor")).FileName or "No code editor set."
                end,
            },
            {
                Title = "Mute VFX",
                Type = "Checkbox",
                UserChange = function(InfoGiven)
                    local Display
                    if Runtime.SettingsManager.Get("SFXEnabled")~=nil then
                        Display = Runtime.SettingsManager.Get("SFXEnabled")
                    else
                        Display = true
                    end
                    Runtime.SettingsManager.Set("SFXEnabled", (not Display))
                end,
                ReturnDisplay = function()
                    local Display
                    if Runtime.SettingsManager.Get("SFXEnabled")~=nil then
                        Display = Runtime.SettingsManager.Get("SFXEnabled")
                    else
                        Display = true
                    end
                    return Display
                end
            }
        },
        Shortcuts = StudioConfig.GenerateShortcuts()
    }, StudioConfig)
end

function StudioConfig.Update(dt)
    
end

return StudioConfig