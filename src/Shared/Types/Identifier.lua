local IdentifierType = {}

function IdentifierType.new(Data, ResourceType, ID)
    ---@class Identifier
    local IdentifierObject = {}

    IdentifierObject.Type = "Identifier"
    IdentifierObject.ResourceType = ResourceType
    IdentifierObject.ID = ID

    IdentifierObject.Data = Data

    return IdentifierObject
end

return IdentifierType