local Serializer = {}

function Serializer.Serialize(Value)
    if Value.ResourceType == "Buffer" then
        print("Attempted to serialize buffer resource")
        return
    end

    return Value
end

function Serializer.Deserialize(Value)
    local Type = Value.ResourceType

    if (not Type) then
        return IdentifierType.new(Path.new(Value.FilePath), "Project")
    else
        error("New identifiers not implemented yet")
    end
end

return Serializer