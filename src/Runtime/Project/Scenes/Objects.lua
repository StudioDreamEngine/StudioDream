-- Handle the serialization of scene objects/things
-- Serialization Definition: Both deserialization and serialization
local Things = Runtime.Things
local Objects = {}

Objects.References = {}

local Serializer = nil ---@class NAMLSerializer
local Deserializer = nil ---@class NAMLDeserializer

local TypeSerializers = Utils.LoadModules("Runtime/Project/Scenes/Serializers/")

-- Set the NAML serializer objects we will be using
function Objects.SetSerializers(InSerializer, InDeserializer)
    Serializer = InSerializer
    Deserializer = InDeserializer
end

-- Serialize a property given its type, the identifier is passed for debugging
function Objects.HandleType(Property, Type, Deserialize, Identifier)
    if (not TypeSerializers[Type]) then error(Type.." needs serializer (@ "..Identifier.Name or "Unknown"..")") end

    if Identifier then
        assert(type(Property) ~= "userdata", "Property "..Identifier.Name.." of Object "..Identifier.Object.." excpected "..Type..", not userdata")
    end

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
local function CheckSerializable(Object, Root)
    local Serializable = true

    ---@param ParentThing Thing
    Object:GetParentCallback(function(ParentThing)
        if not (ParentThing.Serializable) then -- basic serialization check
            Serializable = false
        elseif ParentThing.Scene and (ParentThing.UUID ~= Root.UUID) then -- If the parent is a scene but not the root scene, dont serialize this object
            Serializable = false
        end
    end)

    return Serializable
end


-- Serialize all things under a root object as a table of objects
---@param Root Thing
function Objects.SerializeObjects(Root)
    local ToSerialize = Root:GetDescendants()
    table.insert(ToSerialize, Root)

    ---@param DescendantObject Thing
    for _, DescendantObject in pairs(ToSerialize) do
        if CheckSerializable(DescendantObject, Root) then -- Only serialize if we can
            local Data = Objects.SerializeObject(DescendantObject, Root)

            Serializer.SetCategory(Data.IsRoot and "Root" or "Objects")
            Serializer.AddEntity(Data.Type, Data.UUID, Data.Properties)
        end
    end
end

-- Serialize a single thing into a table that can then be used by the NAML serializer
---@param Object Thing
function Objects.SerializeObject(Object, Root)
    local SerializedProperties = Object.Proxy.Serializable
    local ObjectData = {}

    printVerbose("Serializing Properties for "..Object.Name)

    if Object.Scene and (Object.UUID ~= Root.UUID) then
        return {
            Type = "Scene",
            UUID = Object.UUID,
            Properties = {
                Serializer.CreateData("Identifier", "string", Object.Scene)
            },
            IsRoot = false
        }
    end

    for PropertyName, _ in pairs(SerializedProperties) do
        local Property = Object[PropertyName]
        local Type = Object.Proxy.Types[PropertyName]

        if Property ~= nil then
            -- Special case to make sure Parent UUID of root isnt serialized
            if (PropertyName == "Parent") and (Object.UUID == Root.UUID) then 
                Property = nil
            else
                Property = Objects.HandleType(Property, Type, false,  {
                    Name = PropertyName,
                    Object = Object.UUID
                })
            end
            
            table.insert(ObjectData, Serializer.CreateData(PropertyName, Type, Property))
        end
    end

    return {
        Type = Object.ClassName,
        UUID = Object.UUID,
        Properties = ObjectData,
        IsRoot = (Object.UUID == Root.UUID)
    }
end




-- Deserialize an object from the NAML entity
---@param ObjectData NAMLDeserializedEntity
function Objects.DeserializeObject(ObjectData)
    -- Nasty hack, but we do NOT create the root object or apply properties to it, just return the root itself
    -- TODO: Why are we doing this again?
    if (ObjectData.Type == "Root") then
        return Things.Root, {}
    end

    if ObjectData.Type == "Scene" then
        print("Scene object, skipping load for now")
        return
    end

    local Properties = {}
    local RelocationQueue = {}

    for PropertyName, PropertyData in pairs(ObjectData.Data) do
        local Type = PropertyData.Type
        local Property = Objects.HandleType(PropertyData.Value, Type, true, {
            Object = ObjectData.ID,
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
        return Things.Create(ObjectData.Type, ObjectData.ID)(Properties)
    end, function(Error)
        print(Error)
        print(debug.traceback())
    end)
    
    if (not Success) then
        Shared.QueueAbort("Error while loading Object "..ObjectData.Properties.Name.Value.." ("..ObjectData.ID.."), Traceback in log")
        return
    end

    return Thing, RelocationQueue
end

--[[
    Deserialize the contents of the given NamlObjects

    NamlObjects: The list of objects being deserialized
    Root: The target, or where the objects will be deserialized to
]]
function Objects.DeserializeObjects(Root, NamlObjects)
    Root[1].IsRoot = true

    local ObjectsTable = table.combine(NamlObjects, Root)

    local RelocationQueues = {}
    local LocalReferences = {}

    -- Part 1: Deserialize all objects
    local Deserialize = Profiler.Benchmark("Scene - Deserialize Objects", true)
    for _, ObjectData in pairs(ObjectsTable) do
        local Object, RelocationQueue = Objects.DeserializeObject(ObjectData)

        if ObjectData.IsRoot then -- dumbass hack
            Root = Object
        end

        if Object then
            table.insert(LocalReferences, Object.UUID)
            RelocationQueues[Object] = RelocationQueue
        end
    end
    Deserialize.End()

    local References = {}

    -- Part 2: Resolve local references, Add non-local refs to references table to be resolved
    local Deserialize = Profiler.Benchmark("Scene - Resolve References", true)
    for Object, RelocationQueue in pairs(RelocationQueues) do
        Objects.ResolveLocalReferences(Object, RelocationQueue, LocalReferences)
        References[Object] = RelocationQueue
    end
    Deserialize.End()

    return Root, References
end

-- Resolve all references of an object within the scene
function Objects.ResolveLocalReferences(Object, RelocationQueue, LocalReferences)
    for PropertyName, UUID in pairs(table.clone(RelocationQueue)) do
        if table.findLite(LocalReferences, UUID) then
            Things.SetProperty(Object, PropertyName, Things.Get(UUID))

            RelocationQueue[PropertyName] = nil
        end
    end
end

-- Resolve any non-local references, read more about this in Runtime/Project/Scenes/init.lua
function Objects.ResolveReferences(...)
    local AllRefs = {...}

    for _, References in pairs(AllRefs) do -- For all references
        for Object, RelocationQueue in pairs(References) do -- For all relocationqueues
            for PropertyName, UUID in pairs(RelocationQueue) do -- for all properties
                local ObjectRef = Things.Get(UUID)

                if (not ObjectRef) then
                    printVerbose("No ref")
                else
                    Things.SetProperty(Object, PropertyName, ObjectRef)
                end
            end
        end
    end
end

return Objects