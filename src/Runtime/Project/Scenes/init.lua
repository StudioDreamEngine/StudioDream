---@diagnostic disable: need-check-nil
-- handle serialization of Simple binary Scenes
local Scenes = {}

Scenes.Objects = require("Runtime.Project.Scenes.Objects")

-- Saves the contents of an object binded to a scene to a scene file
function Scenes.SaveScene(Target)
    local Serializer = NAML.Serialize()
    
    Scenes.Objects.SetSerializers(Serializer)
    Scenes.Objects.SerializeObjects(Target)
    
    Runtime.Resources.WriteResource(Target.Scene, Serializer.GenerateNAML())
end

--[[
    Scenes can have references outside of the current that might've not been loaded yet.
    Because of this, we ask you resolve said invalid references once what used them is loaded

    Todo: Automate this in the future
]]
function Scenes.ResolveReferences(...)
    Scenes.Objects.ResolveReferences(...)
end

-- Loads a scene as a scene object
function Scenes.LoadScene(IdentifierID)
    local Resource, Identifier = Runtime.Resources.LoadResourceFromIdentifier(IdentifierID)
    if (not Resource) then error("Invalid IdentifierID "..IdentifierID) end

    return Resource.Instantiate()
end

return Scenes