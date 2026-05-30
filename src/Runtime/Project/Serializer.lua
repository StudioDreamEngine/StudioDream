-- Simple binary serializer
local Things = Runtime.Things
local Serializer = {}

Serializer.Objects = require("Runtime.Project.Objects")

function Serializer.Serialize(Scene)
    local ObjectTable = Serializer.Objects.SerializeObjects(Scene)

    return Binser.serialize(ObjectTable)
end

function Serializer.ConfigureTargets()
    local Root = Things.Root

    Root.EnvironmentViewport:SetRenderFolder(Root:FindFirstChild("Environment"))
end

function Serializer.Deserialize(Content)
    local Table = Binser.deserialize(Content)[1]
    Things.ClearRoot()

    Serializer.Objects.DeserializeObjects(Table.Objects)
    Serializer.ConfigureTargets()
end

return Serializer