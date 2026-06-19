local Serializer = {}

function Serializer.Serialize(Value)
    return Value
end

function Serializer.Deserialize(Value)
    local Identifier = Runtime.Resources.GetIdentifier(Value.Identifier)

    if not Identifier then
        Runtime.Resources.RegisterAsMissing(Value)
        return
    end

    return Identifier
end

return Serializer