---@diagnostic disable: need-check-nil
-- handle serialization of Simple binary Scenes
local Scenes = {}

Scenes.Objects = require("Runtime.Project.Scenes.Objects")

function Scenes.SaveScene(Target)
    local Serializer = NAML.Serialize()
    
    Scenes.Objects.SetSerializers(Serializer)
    Scenes.Objects.SerializeObjects(Target)
    
    Runtime.Resources.WriteResource(Target.Scene, Serializer.GenerateNAML())
end

function Scenes.ResolveReferences(...)
    Scenes.Objects.ResolveReferences(...)
end

function Scenes.LoadScene(IdentifierID)
    local Resource, Identifier = Runtime.Resources.LoadResourceFromIdentifier(IdentifierID)
    if (not Resource) then error("Invalid IdentifierID "..IdentifierID) end

    return Resource.Instantiate()
end

return Scenes