local Serializer = {}

function Serializer.Serialize(Value)
    return Value
end

function Serializer.Deserialize(Value)
    print("Registering buffer "..Value.." as promised (TODO)")
    Runtime.Resources.RegisterPromised(Value)

    return Value
end

return Serializer