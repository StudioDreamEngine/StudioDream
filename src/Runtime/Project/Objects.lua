-- Handle the serialization of scene objects/things
local Things = Runtime.Things
local Objects = {}

local TypeSerializers = Utils.LoadModules("Runtime/Project/Types/")

function Objects.HandleType(Property, Type, Deserialize)
    if (not TypeSerializers[Type]) then error(Type.." needs serializer") end

    local Serializer = require(TypeSerializers[Type])
    local Result = Deserialize and Serializer.Deserialize(Property) or Serializer.Serialize(Property)

    return Result
end

-- Used for updating Thing.TruelySerializable
local function CheckSerializable(Object)
    local Serializable = true

    ---@param ParentThing Thing
    Object:GetParentCallback(function(ParentThing)
        if not (ParentThing.Serializable) and not (ParentThing:IsA("Root")) then
            Serializable = false
        end
    end)

    -- HACK: This could probably be a part of GetParentCallback, and doesnt need to be hacked in like this.
    -- Return false if object itself isnt serializable
    if (not Object.Serializable) then
        return false
    end

    return Serializable
end


-- Serialize all things under a root object as a table of objects
---@param Root Thing
function Objects.SerializeObjects(Root)
    local Final = {}

    ---@param DescendantObject Thing
    for _, DescendantObject in pairs(Root:GetDescendants()) do
        if CheckSerializable(DescendantObject) then -- Only serialize if we can
            Final[DescendantObject.UUID] = Objects.SerializeObject(DescendantObject)
        end
    end

    return Final
end

---@param Object Thing
function Objects.SerializeObject(Object)
    local SerializedProperties = Object.Proxy.Serializable
    local ObjectData = {}

    for PropertyName, _ in pairs(SerializedProperties) do
        local Property = Object[PropertyName]
        local Type = Utils.TypeOf(Property)

        if Type ~= "nil" then
            Property = Objects.HandleType(Property, Type, false)

            ObjectData[PropertyName] = {
                Type = Type,
                Value = Property
            }
        end
    end

    return {
        Type = Object.ClassName,
        UUID = Object.UUID,
        Properties = ObjectData
    }
end




function Objects.DeserializeObject(ObjectData)
    local Properties = {}
    local RelocationQueue = {}

    for PropertyName, PropertyData in pairs(ObjectData.Properties) do
        local Type = PropertyData.Type
        local Property = Objects.HandleType(PropertyData.Value, Type, true)

        if Property then -- Only apply property if it exists
            if Type == "Thing" then
                RelocationQueue[PropertyName] = Property
            else
                Properties[PropertyName] = Property
            end
        end
    end

    local Thing = Things.Create(ObjectData.Type, ObjectData.UUID)(Properties)
    return Thing, RelocationQueue
end

-- Deserialize the contents of the object given above
function Objects.DeserializeObjects(Root)
    local RelocationQueues = {}

    -- Part 1: Deserialize all objects
    for _, Object in pairs(Root) do
        local Object, RelocationQueue = Objects.DeserializeObject(Object)

        RelocationQueues[Object] = RelocationQueue
    end

    -- Part 2: Relocate objects
    for Object, RelocationQueue in pairs(RelocationQueues) do
        for PropertyName, UUID in pairs(RelocationQueue) do
            Things.SetProperty(Object, PropertyName, Things.Get(UUID))
        end
    end
end

return Objects