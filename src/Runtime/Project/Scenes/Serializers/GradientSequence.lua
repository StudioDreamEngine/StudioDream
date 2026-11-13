local Serializer = {}

function Serializer.Serialize(Value)
    local Keys = Value.GetKeys()
    local SerializedKeys = {}

    for i,v in pairs(Keys) do
        table.insert(SerializedKeys,{
            v[1],
            v[2].ToShader()
        })
    end

    return NAML.SerializeList({Keys=SerializedKeys,Rotation=Value.Rotation})
end

function Serializer.Deserialize(Value)
    Value = NAML.DeserializeList(Value)

    local ReconstructKeys = {}

    for i,v in pairs(Value.Keys) do
        table.insert(ReconstructKeys,GradientSequence.NewKey(v[1],Color.new(v[2][1],v[2][2],v[2][3])))
    end

    return GradientSequence.NewSequence(ReconstructKeys,Value.Rotation)
end

return Serializer