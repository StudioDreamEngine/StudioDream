local Serializer = {}

function Serializer.Serialize(Value)
    return NAML.Util.SerializeList(Value:ToSerialize())
end

function Serializer.Deserialize(Value)
    Value = NAML.Util.DeserializeList(Value)

    return Corners.new(Value[1],Value[2],Value[3],Value[4])
end

return Serializer