local Objects = {}

-- Serialize all things under a root object as a table of objects
---@param Root Thing
function Objects.SerializeObjects(Root)
    local Final = {}

    ---@param DescendantObject Thing
    for _, DescendantObject in pairs(Root:GetDescendants()) do
        if DescendantObject.Serializable then -- Only serialize if we can
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

        -- Special Cases
        -- TODO: Make a system for serializing/deserializing types, we can just do this for now as binser handles EVERYTHING
        if Type == "Thing" then
            Property = Property.UUID
        end

        ObjectData[PropertyName] = {
            Type = Type,
            Value = Property
        }
    end

    return ObjectData
end




---@param Object Thing
function Objects.DeserializeObject(Object)
    -- TODO
end

-- Deserialize the contents of the object given above
function Objects.DeserializeObjects(Root)
    -- Part 1: Deserialize all objects seperately

    -- Part 2: Parent objects
end

return Objects