local Serializer = {}

function Serializer.Serialize(Value)
    if Value.ResourceType == "Buffer" then
        printVerbose("Attempted to serialize buffer resource")
        return
    end

    return {
        ResourceType = Value.ResourceType,
        ID = Value.ID
    }
end

function Serializer.Deserialize(Value)
    local Type = Value.ResourceType

    if (not Type) then
        printVerbose("Classic Resource Identifiers are no longer supported ("..Value.Identifier..")")
        Runtime.Resources.RegisterAsMissing(Value.Identifier)
        return
    end

    local Identifier = Runtime.Resources.GetIdentifierFromID(Value.ID)

    if (not Identifier) then
        Runtime.Resources.RegisterAsMissing(Value.ID)
        return
    end

    return Identifier
end

return Serializer