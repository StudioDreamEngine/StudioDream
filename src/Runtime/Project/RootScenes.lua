---@diagnostic disable: need-check-nil
local RootScenes = {}
RootScenes.Registered = {}

local ProjectFS = Runtime.ProjectFS

function RootScenes.Register(SceneObject, SceneName) RootScenes.Registered[SceneObject] = SceneName end

---@param Things Things
function RootScenes.Load(Things)
    table.clear(RootScenes.Registered)
    Runtime.Things.CreateEnviornment()

    local Scenes = Runtime.Project.Scenes
    local NewScenes = {}

    for Object, Scene in pairs(RootScenes.Registered) do
        if ProjectFS.FileExists(Scene..".sds") then
            local Deserializer = NAML.Deserialize(ProjectFS.ReadFile(Scene..".sds"))

            local Return = Scenes.LoadScene(Deserializer, Object, Scene)
            Return:SetParent(Things.Root)

            NewScenes[Return] = Scene
        else
            print("Scene "..Scene.." Doesnt exist! Not loading scene...")
        end
    end

    Scenes.ResolveReferences()
    RootScenes.ConfigureTargets(Things)

    RootScenes.Registered = table.clone(NewScenes) -- Hack to fix issue with RootScenes.Save Referencing root scenes initially created (which have nothing in them)
end

-- Configure Hud and Environment viewports for new root scenes
function RootScenes.ConfigureTargets(Things)
    local Root = Things.Root

    Root.EnvironmentViewport:SetRenderContainer(Root:GetEnvironment())
    Root.HudViewport:SetRenderContainer(Root:GetHUD())
end

function RootScenes.Save()
    local Scenes = Runtime.Project.Scenes

    for Object, Scene in pairs(RootScenes.Registered) do
        Scenes.SaveScene(Scene..".sds", Object)
    end
end

return RootScenes