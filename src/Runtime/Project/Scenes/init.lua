-- handle serialization of Simple binary Scenes
local Things = Runtime.Things
local Scenes = {}

local ProjectFS = Runtime.ProjectFS
local RootScenes = {}

local ObjectsV1 = require("Runtime.Project.Scenes.ObjectsV1")

Scenes.Objects = require("Runtime.Project.Scenes.Objects")
Scenes.LoadDefault = require("Runtime.Project.Scenes.LoadDefault")

function Scenes.RegisterRootScene(SceneObject, SceneName) RootScenes[SceneObject] = SceneName end

function Scenes.SaveScene(Path, Target)
    local ObjectTable = Scenes.Objects.SerializeObjects(Target)

    local Data = Binser.serialize({
        Objects = ObjectTable
    })

    ProjectFS.QueueWrite(Path, Data)
end

function Scenes.ResolveReferences()
    Scenes.Objects.ResolveReferences()
    ObjectsV1.ResolveReferences() -- Should figure out a better way to do this
end

function Scenes.LoadScene(Path)
    if (not ProjectFS.FileExists(Path)) then
        print("Scene "..Path.." Doesnt exist! Not loading scene...")
        return
    end

    print("Loading Scene: "..Path)

    local Success, Message = xpcall(function()
        local Content = ProjectFS.ReadFile(Path)
        local Table = Binser.deserialize(Content)[1]

        if (not Table.Objects) then
            print("Attempting to load as V1 scene, might not work!")
            ObjectsV1.DeserializeObjects(Table)
        else
            if Path == "MainScene.sds" then
                love.filesystem.write("TempLevel", table.format(Table))
            end

            local Scene = Scenes.Objects.DeserializeObjects(Table.Objects)
            return Scene
        end
    end, function(Error)
        print(Error)
    end)

    if Success then
        return Message
    else
        Shared.QueueAbort("Error while loading scene: "..Path)
    end
end

-- Either load the scene or default to an already created object, said object will be deleted if the scene is loaded successfully
function Scenes.LoadSceneOrDefault(Path, Default)
    if (not ProjectFS.FileExists(Path)) then
        return Default
    end

    Default:Destroy()
    return Scenes.LoadScene(Path)
end

function Scenes.LoadRootScenes(Mode)
    local Function = (Mode == "Load") and "LoadSceneOrDefault" or "SaveScene"
    local ScenesList = {}

    for Object, Scene in pairs(RootScenes) do
        local Return = Scenes[Function](Scene..".sds", Object)
        if Return then table.insert(ScenesList, Return) end
    end

    if Mode == "Load" then
        for _, Scene in pairs(ScenesList) do
            Scene:SetParent(Things.Root)
        end

        Scenes.ResolveReferences()
        
        -- Configure enviornment
        --Things.Root.RootViewport:SetRenderContainer(Things.Root:GetEnvironment())
        Things.Root.EnvironmentViewport:SetRenderContainer(Things.Root:GetEnvironment())
    end
end

return Scenes