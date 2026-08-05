local RootScenes = {}
local Registered = {}

local ProjectFS = Runtime.ProjectFS
local Things = Runtime.Things

function RootScenes.Register(SceneObject, SceneName) Registered[SceneObject] = SceneName end

function RootScenes.Load()
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

    Registered = table.clone(NewScenes) -- Hack to fix issue with RootScenes.Save() Referencing root scenes initially created (which have nothing in them)
    
    -- Configure enviornment
    Things.Root.EnvironmentViewport:SetRenderContainer(Things.Root:GetEnvironment())
end

function RootScenes.Save()
    local Scenes = Runtime.Project.Scenes

    for Object, Scene in pairs(Registered) do
        Scenes.SaveScene(Scene..".sds", Object)
    end
end

return RootScenes