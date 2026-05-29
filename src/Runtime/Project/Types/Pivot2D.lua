local Serializer = {}

function Serializer.Serialize(Value)
    return {
        Scale = Value.Scale.Simple(),
        Offset = Value.Offset.Simple()
    }
end

function Serializer.Deserialize(Value)
    local Offset = Vector2.FromSimple(Value.Offset)
    local Scale = Vector2.FromSimple(Value.Scale)

    return Pivot2D.new(Offset.X, Scale.X, Offset.Y, Scale.Y)
end

return Serializer