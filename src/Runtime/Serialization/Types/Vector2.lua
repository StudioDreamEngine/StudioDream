local Serializer = {}

function Serializer.Serialize(Value)
    return {
        X = Value.X,
        Y = Value.Y
    }
end

function Serializer.Deserialize(Value)
    return Vector2.new(Value.X, Value.Y)
end

return Serializer