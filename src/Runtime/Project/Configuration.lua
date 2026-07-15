local Configuration = {}

local DefaultConfig = {
    Name = "Untitled"
}

function Configuration.Set(Key, Value)
    Configuration.Config[Key] = Value
    Configuration.Save()
end

function Configuration.GetDefault()
    return table.clone(DefaultConfig)
end

Configuration.Config = Configuration.GetDefault()

function Configuration.Get(Key)
    return Configuration.Config[Key]
end

function Configuration.Load(Path)
    local ConfigData

    if Path then
        ConfigData = Runtime.BaseFS.ReadFile(Path.."Project.sdc")
    else
        ConfigData = Runtime.ProjectFS.ReadFile("Project.sdc")
    end

    if ConfigData then
        local Deserialized = Binser.deserialize(ConfigData)[1]
        local Config = Configuration.GetDefault()

        -- Hydrate default config with deserialized config
        for Setting, Value in pairs(Deserialized) do
            Config[Setting] = Value
        end

        print("Loaded new config: ",Config)

        -- Set config to hydrated config only if this isnt being called to grab a config of a non-loaded project
        if (not Path) then
            Configuration.Config = Config
        end

        return Config
    end
end

function Configuration.Save()
    local Serialized = Binser.serialize(Configuration.Config)
    Runtime.ProjectFS.WriteFile("Project.sdc", Serialized)
end

return Configuration