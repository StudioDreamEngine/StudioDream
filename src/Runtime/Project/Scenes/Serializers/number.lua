local Serializer = {}

function Serializer.Serialize(Value)
    return tostring(Value)
end

function Serializer.Deserialize(Value)
    return tonumber(Value)
end

return Serializer