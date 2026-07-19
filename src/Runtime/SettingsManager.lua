local SettingsManager = {}
local Settings = {}

local DefaultSettings = {
    CodeEditor = nil,
    Projects = {},
    Version = 2
}

function SettingsManager.Init()
    local SettingsData = love.filesystem.read("StudioSettings.dat")
    
    Settings = table.clone(DefaultSettings)

    if SettingsData then
        local Deserialized = Binser.deserialize(SettingsData)[1]

        if Deserialized.Version ~= DefaultSettings.Version then
            print("Outdated settings version")
            Deserialized.Projects = {} -- reset project history each ver update for now
            Deserialized.Version = DefaultSettings.Version
        end

        for Setting, Value in pairs(Deserialized) do
            Settings[Setting] = Value
        end
    end
end

function SettingsManager.ChangeSetting(Setting, Value)
    Settings[Setting] = Value
    SettingsManager.Save()
end

function SettingsManager.Save()
    local Serialized = Binser.serialize(Settings)
    love.filesystem.write("StudioSettings.dat", Serialized)
end

function SettingsManager.GetSetting(Setting)
    --print(DefaultSettings)
    return Settings[Setting]
end

return SettingsManager