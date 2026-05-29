local Serializer = {}

function Serializer.Serialize(Value)
    local Position = Value.Position

    return {
        X = Position.X,
        Y = Position.Y,
        Z = Position.Z
    }
end

function Serializer.Deserialize(Value)
    return Transform3D.FromPosition(Value.X, Value.Y, Value.Z)
end

return Serializer