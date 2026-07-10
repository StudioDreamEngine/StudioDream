-- handle serialization of Simple binary Scenes
local Things = Runtime.Things
local Scenes = {}

local ProjectFS = Runtime.ProjectFS
local RootScenes = {}

Scenes.Objects = require("Runtime.Project.Scenes.Objects")
Scenes.LoadDefault = require("Runtime.Project.Scenes.LoadDefault")

function Scenes.RegisterRootScene(SceneObject, SceneName) RootScenes[SceneObject] = SceneName end

function Scenes.SaveScene(Path, Target)
    local ObjectTable = Scenes.Objects.SerializeObjects(Target)

    love.filesystem.write("TempLevel", table.format(ObjectTable))

    local Data = Binser.serialize(ObjectTable)
    ProjectFS.WriteFile(Path, Data)
end

function Scenes.ConfigureTargetsTemp()
    ---@class Thing
    local Environment = Things.GetRoot("Environment")
    Environment.Camera = Environment:FindFirstChild("Camera")
end

function Scenes.ResolveReferences()
    Scenes.Objects.ResolveReferences()
end

function Scenes.LoadScene(Path, Target)
    if (not ProjectFS.FileExists(Path)) then
        print("Scene "..Path.." Doesnt exist! Not loading scene...")
        return
    end

    print("Loading Scene: "..Path)

    local Success, Message = xpcall(function()
        local Content = ProjectFS.ReadFile(Path)
        local Table = Binser.deserialize(Content)[1]

        Scenes.Objects.DeserializeObjects(Table, Target)
        Scenes.ConfigureTargetsTemp()
    end, function(Error)
        print(Error)
        print(debug.traceback())
    end)

    if Success then
        return Message
    else
        Shared.QueueAbort("Error while loading scene: "..Path)
    end
end

function Scenes.LoadRootScenes(Mode)
    for Object, Scene in pairs(RootScenes) do
        Scenes[Mode.."Scene"](Scene..".sds", Object)
    end

    if Mode == "Load" then
        Scenes.ResolveReferences()
        Scenes.ConfigureTargetsTemp()
    end
end

return Scenes