-- Simple binary serializer
local Things = Runtime.Things
local Serializer = {}

Serializer.Objects = require("Runtime.Serialization.Objects")

function Serializer.Serialize()
    local ObjectTable = Serializer.Objects.SerializeObjects(Things.Root)

    print(ObjectTable)
end

function Serializer.Deserialize(Content)
    
end

return Serializer