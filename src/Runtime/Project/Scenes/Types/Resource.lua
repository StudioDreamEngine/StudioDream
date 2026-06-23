local Serializer = {}

function Serializer.Serialize(Value)
    return Value
end

function Serializer.Deserialize(Value)
    local Identifier = Runtime.Resources.GetIdentifierFromID(Value.Identifier)

    if (not Identifier) then
        print("Register missing")
        Runtime.Resources.RegisterAsMissing(Value)
        return
    end

    return Identifier
end

return Serializer