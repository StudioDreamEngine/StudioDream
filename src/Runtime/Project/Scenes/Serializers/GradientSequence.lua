local Serializer = {}

function Serializer.Serialize(Value)
    local Keys = Value.GetKeys()

    return NAML.SerializeList({Keys=Keys,Rotation=Value.Rotation})
end

function Serializer.Deserialize(Value)
    Value = NAML.DeserializeList(Value)
    local ReconstructKeys = {}
    for i,v in pairs(Value.Keys) do
        table.insert(ReconstructKeys,GradientSequence.NewKey(v[1],v[2]))
    end
    return GradientSequence.NewSequence(ReconstructKeys,Value.Rotation)
end

return Serializer