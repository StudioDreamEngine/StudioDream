local IdentifierType = {}

function IdentifierType.new(Data, ResourceType)
    ---@class Identifier
    local IdentifierObject = {}

    IdentifierObject.Type = "Identifier"
    IdentifierObject.ResourceType = ResourceType
    IdentifierObject.ID = "Buffer-"..CreateUUID()

    IdentifierObject.Data = Data

    return IdentifierObject
end

return IdentifierType