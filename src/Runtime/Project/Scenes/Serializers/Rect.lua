local Serializer = {}

function Serializer.Serialize(Value)
    return NAML.SerializeList({
        Origin = Value.Origin:Simple(),
        Size = Value.Size:Simple()
    })
end

function Serializer.Deserialize(Value)
    Value = NAML.DeserializeList(Value)

    local Origin = Vector2.FromSimple(Value.Origin)
    local Size = Vector2.FromSimple(Value.Size)

    return Rect.new(Origin, Size)
end

return Serializer