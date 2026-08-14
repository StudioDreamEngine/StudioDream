local RootScenes = {}
local Registered = {}

local ProjectFS = Runtime.ProjectFS

function RootScenes.Register(SceneObject, SceneName) Registered[SceneObject] = SceneName end

---@param Things Things
function RootScenes.Load(Things)
    local Scenes = Runtime.Project.Scenes
    local NewScenes = {}

    for Object, Scene in pairs(Registered) do
        Object:ClearAllChildren()

        if ProjectFS.FileExists(Scene..".sds") then
            local Content = ProjectFS.ReadFile(Scene..".sds")
            local Table = Binser.deserialize(Content)[1]

            local Return = Scenes.LoadScene(Table, Object, Scene)
            Return:SetParent(Things.Root)

            NewScenes[Return] = Scene
        else
            print("Scene "..Scene.." Doesnt exist! Not loading scene...")
        end
    end
    Scenes.ResolveReferences()
    RootScenes.ConfigureTargets(Things)

    Registered = table.clone(NewScenes) -- Hack to fix issue with RootScenes.Save Referencing root scenes initially created (which have nothing in them)
end

-- Configure Hud and Environment viewports for new root scenes
function RootScenes.ConfigureTargets(Things)
    local Root = Things.Root

    Root.EnvironmentViewport:SetRenderContainer(Root:GetEnvironment())
    Root.HudViewport:SetRenderContainer(Root:GetHUD())
end

function RootScenes.Save()
    local Scenes = Runtime.Project.Scenes

    for Object, Scene in pairs(Registered) do
        Scenes.SaveScene(Scene..".sds", Object)
    end
end

return RootScenes