local Serializer = {}

function Serializer.Serialize(Value)
    return Value
end

function Serializer.Deserialize(Value)
    return Value or ""
end

return Serializer