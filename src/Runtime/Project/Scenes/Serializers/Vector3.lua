local Serializer = {}

function Serializer.Serialize(Value)
    return {
        X = Value.X,
        Y = Value.Y,
        Z = Value.Z
    }
end

function Serializer.Deserialize(Value)
    return Vector3.new(Value.X, Value.Y, Value.Z)
end

return Serializer