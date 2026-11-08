local SerializationService = {}

local NeedSerializer = {
    Enum.Serializer.NAML
}

local ServicePath = "Runtime.Backend.Services.SerializationService."

local function SimpleSerialize(Type, Data, Deserialize)
    assert(not table.find(NeedSerializer, Type), Type.." only works with a serializer object")

    local Serializer = SerializationService.CreateSerializer(Type)

    if Deserialize then
        return Serializer.Serialize(Data)
    else
        return Serializer.Deserialize(Data)
    end
end

function SerializationService.CreateSerializer(SerializerType, Config)
    return require(ServicePath..SerializerType)(Config)
end

function SerializationService.Serialize(SerializerType, Data) return SimpleSerialize(SerializerType, Data, false) end
function SerializationService.Deserialize(SerializerType, Data) return SimpleSerialize(SerializerType, Data, true) end

return SerializationService