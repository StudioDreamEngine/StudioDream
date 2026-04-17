local Serialization = {}

Serialization.CurrentSerializer = "Binary" -- This will be used in the future, for now it doesnt matter much

local Serializer = require("Serializer")

function Serialization.Load(File)
end

local Root = Runtime.Things.Root

function Serialization.Save()
    -- Temporary
    Serializer.Serialize(Root.Viewport)
end

return Serialization