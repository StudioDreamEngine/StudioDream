local SettingsManager = {}
local Settings = {}

local DefaultSettings = {
    CodeEditor = nil
}

function SettingsManager.Init()
    local SettingsData = love.filesystem.read("StudioSettings.dat")
    
    if SettingsData then
        local Deserialized = Binser.deserialize(SettingsData)[1]

        Settings = table.clone(DefaultSettings)

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
    return Settings[Setting]
end

return SettingsManager