local Serializer = {}

--Serializer.SerializeType(Property, Type, Deserialize, Identifier)

function Serializer.Serialize(Value)
    local Type = Utils.TypeOf(Value)
    local Serialized = {
        Type = Type,
        New = true,
        Data = Serializer.SerializeType(Value, Type, false)
    }

    return Serialized
end

function Serializer.Deserialize(Value)
    if (not Value.New) then
        print("Serialized enum was incorrectly serialized, re-save the project.")
        return
    else
        return Serializer.SerializeType(Value.Data, Value.Type, true)
    end
end

return Serializer