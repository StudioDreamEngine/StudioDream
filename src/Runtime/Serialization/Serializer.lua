-- Simple binary serializer
local Things = Runtime.Things
local Serializer = {}

Serializer.Objects = require("Runtime.Serialization.Objects")

local TempSerialized

function Serializer.Serialize()
    local ObjectTable = Serializer.Objects.SerializeObjects(Things.Root)

    print(ObjectTable)

    TempSerialized = Binser.serialize(ObjectTable)
end

function Serializer.Deserialize(Content)
    --local Table = Binser.deserialize(TempSerialized)[1]

    Things.ClearRoot()

--    Serializer.Objects.DeserializeObjects(Table)
end

return Serializer