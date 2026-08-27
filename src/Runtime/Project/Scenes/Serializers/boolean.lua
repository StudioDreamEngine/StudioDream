local Serializer = {}

local TrueValues = {"true", "yes"}

function Serializer.Serialize(Value)
    return tostring(Value)
end

function Serializer.Deserialize(Value)
    return table.find(TrueValues, string.lower(Value))
end

return Serializer