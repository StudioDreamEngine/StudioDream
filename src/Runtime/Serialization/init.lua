local Serialization = {}

Serialization.CurrentSerializer = "Binary" -- This will be used in the future, for now it doesnt matter much

local Serializer = require("Runtime.Serialization.Serializer")

function Serialization.Load(File)
    Serializer.Deserialize()
end

local Root = Runtime.Things.Root

function Serialization.Save()
    -- Temporary
    Serializer.Serialize(Root)
end

return Serialization