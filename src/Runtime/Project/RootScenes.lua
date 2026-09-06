---@diagnostic disable: cast-local-type, need-check-nil
local Root = Runtime.Things.Root

local RootScenes = {}
RootScenes.Default = {}
RootScenes.Loaded = {}

function RootScenes.Register(SceneObject, SceneName) RootScenes.Default[SceneName] = SceneObject end

function RootScenes.LoadDefault()
    Root:Clear()

    for Name, Default in pairs(RootScenes.Default) do
        local Object = Default:Clone()
        Object:SetParent(Root)

        RootScenes.Loaded[Name] = {
            Object = Object,
            Identifier = nil
        }
    end

    Runtime.Project.Scenes.LoadDefault()
    RootScenes.ConfigureTargets()
end

function RootScenes.Load()
    local Project = Runtime.Project
    Root:Clear()

    local ScenesConfig = Project.Config.Get("RootScenes")
    local RootRefs = {}

    for Name, Default in pairs(RootScenes.Default) do
        local Identifier = ScenesConfig[Name]

        local Resource = {
            References = {},
            Scene = nil
        }

        if Identifier then
            Resource = Runtime.Resources.LoadResourceFromIdentifier(Identifier)

            table.insert(RootRefs, Resource.References)
        end

        Object = (Resource.Scene or Default):Clone()
        Object:SetParent(Root)

        RootScenes.Loaded[Name] = {
            Object = Object,
            Identifier = nil
        }
    end

    Project.Scenes.ResolveReferences(unpack(RootRefs))
    RootScenes.ConfigureTargets()
end

-- Configure Hud and Environment viewports for new root scenes
function RootScenes.ConfigureTargets()
    Root.EnvironmentViewport:SetRenderContainer(Root:GetEnvironment())
    Root.HudViewport:SetRenderContainer(Root:GetHUD())
end

function RootScenes.Save()
    local Project = Runtime.Project
    local ScenesConfig = {}

    for Name, Loaded in pairs(RootScenes.Loaded) do
        if (not Loaded.Identifier) then
            Loaded.Identifier = Runtime.Resources.GetOrCreateIdentifierID(Name..".sds") -- Currently if a default is missing, it just makes its own identifier
        end

        Project.Scenes.SaveScene(Loaded.Identifier, Loaded.Object)

        ScenesConfig[Name] = Loaded.Identifier
    end

    Project.Config.Set("RootScenes", ScenesConfig)
end

return RootScenes