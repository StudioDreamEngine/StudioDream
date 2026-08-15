---@diagnostic disable: need-check-nil
-- handle serialization of Simple binary Scenes
local Scenes = {}

local ProjectFS = Runtime.ProjectFS
local ObjectsV1 = require("Runtime.Project.Scenes.ObjectsV1")

Scenes.Objects = require("Runtime.Project.Scenes.Objects")
Scenes.LoadDefault = require("Runtime.Project.Scenes.LoadDefault")

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

function Scenes.LoadScene(Resource, Default, Path)
    print("Loading Scene: "..Path)

    local Success, Message = xpcall(function()
        if (not Resource.Objects) then
            print("Attempting to load as V1 scene, might not work!")
            ObjectsV1.DeserializeObjects(Resource, Default)

            Runtime.Project.NotificationCallback("Loaded "..Path.." as V1 scene, V1 scenes will not be supported after 0.9")
        else
            if Default then Default:Destroy() end

            local Scene = Scenes.Objects.DeserializeObjects(Resource.Objects)
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

function Scenes.LoadFromIdentifier(IdentifierID, Default)
    local Resource, Identifier = Runtime.Resources.LoadResourceFromIdentifier(IdentifierID)
    if (not Resource) then error("Invalid IdentifierID "..IdentifierID) end

    return Scenes.LoadScene(Resource, Default, Identifier.ID)
end

return Scenes