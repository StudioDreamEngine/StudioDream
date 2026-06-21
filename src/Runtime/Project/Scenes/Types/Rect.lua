local Serializer = {}

function Serializer.Serialize(Value)
    return {
        Origin = Value.Origin.Simple(),
        Size = Value.Size.Simple()
    }
end

function Serializer.Deserialize(Value)
    local Origin = Vector2.FromSimple(Value.Origin)
    local Size = Vector2.FromSimple(Value.Size)

    return Rect.new(Origin, Size)
end

return Serializer