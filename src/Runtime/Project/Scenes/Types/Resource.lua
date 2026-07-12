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
        return IdentifierType.new(Path.new(Value.FilePath), "Project", Value.Identifier)
    else
        local Data = Value.Data
        return IdentifierType.new(Path.new(Data.FilePath), "Project", Value.ID)
    end
end

return Serializer