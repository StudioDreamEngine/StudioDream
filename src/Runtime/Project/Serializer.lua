-- Simple binary serializer
local Things = Runtime.Things
local Serializer = {}

Serializer.Objects = require("Runtime.Project.Objects")

function Serializer.Serialize(Scene)
    local ObjectTable = {
        Scene = Scene.UUID,
        Objects = Serializer.Objects.SerializeObjects(Things.Root)
    }

    local file = love.filesystem.openFile("test", "w")
    file:write(table.format(ObjectTable))
    file:close()

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