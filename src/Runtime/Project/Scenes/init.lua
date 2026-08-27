---@diagnostic disable: need-check-nil
-- handle serialization of Simple binary Scenes
local Scenes = {}

local ProjectFS = Runtime.ProjectFS

Scenes.Objects = require("Runtime.Project.Scenes.Objects")
Scenes.LoadDefault = require("Runtime.Project.Scenes.LoadDefault")

function Scenes.SaveScene(Path, Target)
    local Serializer = NAML.Serialize()
    
    Scenes.Objects.SetSerializers(Serializer)
    Scenes.Objects.SerializeObjects(Target)

    ProjectFS.QueueWrite(Path, Serializer.GenerateNAML())
end

function Scenes.ResolveReferences()
    Scenes.Objects.ResolveReferences()
end

---@param Deserializer NAMLDeserializer
function Scenes.LoadScene(Deserializer, Default, Path)
    print("Loading Scene: "..Path)

    local Success, Message = xpcall(function()
        if Default then Default:Destroy() end

        Scenes.Objects.SetSerializers(nil, Deserializer)

        local Scene = Scenes.Objects.DeserializeObjects(Deserializer.GetCategory("Root"), Deserializer.GetCategory("Objects"))
        return Scene
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