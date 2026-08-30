local Serializer = {}

local TrueValues = {"true", "yes"}

function Serializer.Serialize(Value)
    return tostring(Value)
end

function Serializer.Deserialize(Value)
    return (table.findLite(TrueValues, string.lower(Value)) and true or false)
end

return Serializer