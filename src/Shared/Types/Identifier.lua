local Identifier = {}

function Identifier.new(Data, ResourceType, Identifier)
    ---@class Identifier
    local IdentifierObject = {}

    IdentifierObject.Type = "Identifier"
    IdentifierObject.ResourceType = ResourceType
    IdentifierObject.ID = Identifier

    IdentifierObject.Data = Data

    return IdentifierObject
end

return Identifier