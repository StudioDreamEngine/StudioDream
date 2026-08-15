-- Handle the serialization of scene objects/things
local Things = Runtime.Things
local Objects = {}

Objects.References = {}

local TypeSerializers = Utils.LoadModules("Runtime/Project/Scenes/Serializers/")

function Objects.HandleType(Property, Type, Deserialize, Identifier)
    if (not TypeSerializers[Type]) then error(Type.." needs serializer (@ "..Identifier.Name or "Unknown"..")") end

    local Serializer = require(TypeSerializers[Type])
    Serializer.SerializeType = Objects.HandleType

    local Result

    if Deserialize then
        Result = Serializer.Deserialize(Property)
    else
        Result = Serializer.Serialize(Property)
    end

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

    local ToSerialize = Root:GetDescendants()
    table.insert(ToSerialize, Root)

    ---@param DescendantObject Thing
    for _, DescendantObject in pairs(ToSerialize) do
        if CheckSerializable(DescendantObject) then -- Only serialize if we can
            Final[DescendantObject.UUID] = Objects.SerializeObject(DescendantObject, Root)
        end
    end

    return Final
end

---@param Object Thing
function Objects.SerializeObject(Object, Root)
    local SerializedProperties = Object.Proxy.Serializable
    local ObjectData = {}

    printVerbose("Serializing Properties for "..Object.Name)

    for PropertyName, _ in pairs(SerializedProperties) do
        local Property = Object[PropertyName]
        local Type = Object.Proxy.Types[PropertyName]

        if Property ~= nil then
            -- Special case to make sure Parent UUID of root isnt serialized
            if (PropertyName == "Parent") and (Object.UUID == Root.UUID) then 
                Property = nil
            else
                Property = Objects.HandleType(Property, Type, false,  {
                    Name = PropertyName
                })
            end
            
            ObjectData[PropertyName] = {
                Type = Type,
                Value = Property
            }
        end
    end

    return {
        Type = Object.ClassName,
        UUID = Object.UUID,
        Properties = ObjectData,
        IsRoot = (Object.UUID == Root.UUID)
    }
end






function Objects.DeserializeObject(ObjectData)
    local Properties = {}
    local RelocationQueue = {}

    for PropertyName, PropertyData in pairs(ObjectData.Properties) do
        local Type = PropertyData.Type
        local Property = Objects.HandleType(PropertyData.Value, Type, true, {
            --Object = ObjectData.UUID,
            Name = PropertyName
        })

        if Property then -- Only apply property if it exists
            if Type == "Thing" then
                RelocationQueue[PropertyName] = Property
            else
                Properties[PropertyName] = Property
            end
        end
    end

    local Success, Thing = xpcall(function(...)
        return Things.Create(ObjectData.Type, ObjectData.UUID)(Properties)
    end, function(Error)
        print(Error)
        print(debug.traceback())
    end)
    
    if (not Success) then
        Shared.QueueAbort("Error while loading Object "..ObjectData.Properties.Name.Value.." ("..ObjectData.UUID.."), Traceback in log")
        return
    end

    return Thing, RelocationQueue
end

-- Deserialize the contents of the object given above
--[[
    Objects: The list of objects being deserialized
    Root: The target, or where the objects will be deserialized to
]]
function Objects.DeserializeObjects(ObjectsTable)
    local RelocationQueues = {}
    local LocalReferences = {}
    local RootObject

    -- Part 1: Deserialize all objects
    local Deserialize = Profiler.Benchmark("Scene - Deserialize Objects", true)
    for _, ObjectData in pairs(ObjectsTable) do
        local Object, RelocationQueue = Objects.DeserializeObject(ObjectData)

        if Object then
            if ObjectData.IsRoot then RootObject = Object end -- Resolve root object

            table.insert(LocalReferences, Object.UUID)
            RelocationQueues[Object] = RelocationQueue
        end
    end
    Deserialize.End()

    -- Part 2: Resolve local references, Add non-local refs to references table to be resolved
    local Deserialize = Profiler.Benchmark("Scene - Resolve References", true)
    for Object, RelocationQueue in pairs(RelocationQueues) do
        Objects.ResolveLocalReferences(Object, RelocationQueue, LocalReferences)
        Objects.References[Object] = RelocationQueue
    end
    Deserialize.End()

    return RootObject
end

function Objects.ResolveLocalReferences(Object, RelocationQueue, LocalReferences)
    for PropertyName, UUID in pairs(table.clone(RelocationQueue)) do
        if table.findLite(LocalReferences, UUID) then
            Things.SetProperty(Object, PropertyName, Things.Get(UUID))

            RelocationQueue[PropertyName] = nil
        end
    end
end

-- Resolve any non-local references
function Objects.ResolveReferences()
    for Object, RelocationQueue in pairs(Objects.References) do
        for PropertyName, UUID in pairs(RelocationQueue) do
            Things.SetProperty(Object, PropertyName, Things.Get(UUID))
        end
    end

    Objects.References = {}
end

return Objects