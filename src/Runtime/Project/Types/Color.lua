local Serializer = {}

function Serializer.Serialize(Value)
    return {
        R = Value.R,
        G = Value.G,
        B = Value.B
    }
end

function Serializer.Deserialize(Value)
    return Color.new(Value.R, Value.G, Value.B)
end

return Serializer