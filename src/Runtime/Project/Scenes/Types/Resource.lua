local Serializer = {}

function Serializer.Serialize(Value)
    return Value
end

function Serializer.Deserialize(Value)
    local Type = Value.ResourceType

    if (not Type) then
        return Identifier.new(Path.new(Value.FilePath), "Project", Value.Identifier)
    else
        error("New identifiers not implemented yet")
    end
end

return Serializer