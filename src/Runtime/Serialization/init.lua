local Serialization = {}
local Serializer = require("Runtime.Serialization.Serializer")

function Serialization.Load(ProjectPath)
    Serializer.Deserialize()
end

function Serialization.Save(ProjectPath)
    Serializer.Serialize(Runtime.Things.Root)
end

return Serialization