local Serializer = {}

function Serializer.Serialize(Value)
    return Value.UUID
end

function Serializer.Deserialize(Value)
    return Value
end

return Serializer