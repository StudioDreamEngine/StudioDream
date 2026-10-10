local Configuration = {}

local DefaultConfig = {
    Name = "Untitled",
    Identifier = nil,
    RootScene = nil, -- The root scene itself that holds the root tree
    MainScene = nil, -- The initial scene to load,

    WindowSize = Vector2.new(1060, 600),
    WindowResizable = true,

    EditorData = {
        Tabs = {}
    }, -- Editor-Specific data
    FormatVersion = 2, -- The version of the save format
}

Configuration.OnChange = Signal:New("ConfigurationChanged")

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

---@param Mount? MountFS
function Configuration.Load(Mount)
    local ConfigData

    if Mount then
        ConfigData = Mount.ReadFile("Project.sdc")
    else
        ConfigData = Runtime.ProjectFS.ReadFile("Project.sdc")
    end

    local Success, Message = pcall(function()
        if ConfigData then
            local Deserialized = JSON.decode(ConfigData)
            local Config = Configuration.GetDefault()

            -- Hydrate default config with deserialized config
            for Setting, Value in pairs(Deserialized) do
                Config[Setting] = Value
            end

            printVerbose("Loaded new config: ",Config)

            -- Set config to hydrated config only if this isnt being called to grab a config of a non-loaded project
            if (not Mount) then
                if Config.FormatVersion ~= DefaultConfig.FormatVersion then
                    Shared.QueueAbort("Project is too old!")
                    return
                end

                Configuration.Config = Config
            end

            Configuration.OnChange.Invoke()

            return Config
        elseif (not Mount) then
            Shared.QueueAbort("Project configuration doesnt exist!")
        end
    end)

    if (not Success) and (not Mount) then
        Utils.Warning("Couldn't load project configuration")

        Configuration.Config = Configuration.GetDefault()
        return Configuration.Config
    else
        return Message
    end
end

function Configuration.Save()
    local Serialized = JSON.encode(Configuration.Config)
    Runtime.ProjectFS.QueueWrite("Project.sdc", Serialized)

    Configuration.OnChange.Invoke()
end

return Configuration