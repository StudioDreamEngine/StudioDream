local Serializer = {}

function Serializer.Serialize(Value)
    return Value.UUID
end

function Serializer.Deserialize(Value)
    return Value -- We need to grab it after
end

return Serializer