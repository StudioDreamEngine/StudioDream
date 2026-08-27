local Serializer = {}

function Serializer.Serialize(Value)
    return NAML.SerializeList({
        X = Value.X,
        Y = Value.Y
    })
end

function Serializer.Deserialize(Value)
    Value = NAML.DeserializeList(Value)

    return Vector2.new(Value.X, Value.Y)
end

return Serializer