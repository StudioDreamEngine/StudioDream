local SettingsManager = {}
local Settings = {}

local DefaultSettings = {
    CodeEditor = nil,
    ProjectHistory = {},
    Version = 2,
    SFXEnabled = true,
    UsingTheme = "Blue Night",
    AutomaticCreation = true,
    FlagCreation = false -- If or if not we've shown the automatic creation dialog
}

function SettingsManager.Init()
    local SettingsData = love.filesystem.read("StudioSettings.dat")
    
    Settings = table.clone(DefaultSettings)

    if SettingsData then
        local Success, _ = pcall(function()
            local Deserialized = JSON.decode(SettingsData)

            if Deserialized.Version ~= DefaultSettings.Version then
                print("Outdated settings version")
                Deserialized.Projects = {} -- reset project history each ver update for now
                Deserialized.Version = DefaultSettings.Version
            end

            for Setting, Value in pairs(Deserialized) do
                Settings[Setting] = Value
            end
        end)

        if (not Success) then
            printVerbose("Could not read StudioSettings.dat, using defaults...")
        end
    else
        printVerbose("StudioSettings.dat not found, using defaults")
    end
end

local function GetStudioData() return Runtime.Project.Config.Get("EditorData") end
local function SaveStudioData() return Runtime.Project.Config.Save() end

function SettingsManager.SetProject(Setting, Value)
    GetStudioData()[Setting] = Value
    SaveStudioData()
end

function SettingsManager.GetProject(Setting)
    return GetStudioData()[Setting]
end

function SettingsManager.Set(Setting, Value)
    Settings[Setting] = Value
    SettingsManager.Save()
end

function SettingsManager.Save()
    local Serialized = JSON.encode(Settings)
    love.filesystem.write("StudioSettings.dat", Serialized)
end

function SettingsManager.Get(Setting)
    --print(DefaultSettings)
    return Settings[Setting]
end

return SettingsManager