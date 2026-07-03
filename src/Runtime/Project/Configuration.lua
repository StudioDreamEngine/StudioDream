local Configuration = {}

Configuration.Config = {
    Name = "UnNamed"
}

function Configuration.SetConfig(Key, Value)
    Configuration.Config[Key] = Value
    Configuration.Save()
end

function Configuration.GetConfig(Key)
    return Configuration.Config[Key]
end

function Configuration.Load()
    local ConfigData = Runtime.ProjectFS.ReadFile("Project.sdc")

    if ConfigData then
        local Deserialized = Binser.deserialize(ConfigData)[1]

        for Setting, Value in pairs(Deserialized) do
            Configuration.Config[Setting] = Value
        end
    end
end

function Configuration.Save()
    local Serialized = Binser.serialize(Configuration.Config)
    Runtime.ProjectFS.WriteFile("Project.sdc", Serialized)
end

return Configuration