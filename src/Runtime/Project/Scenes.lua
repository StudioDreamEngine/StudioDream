-- Simple binary Scenes
local Things = Runtime.Things
local Scenes = {}

local BackendFS = Runtime.BackendFS

Scenes.Objects = require("Runtime.Project.Objects")

function Scenes.SaveScene(Path, Target)
    local ObjectTable = Scenes.Objects.SerializeObjects(Target)

    local Data = Binser.serialize(ObjectTable)
    BackendFS.WriteFile(Path, Data)
end

-- Re-configure targets for project if needed
function Scenes.ConfigureTargets()
    local Root = Things.Root

    Root.EnvironmentViewport:SetRenderFolder(Root:FindFirstChild("Environment"))
end

function Scenes.LoadScene(Path)
    local Content = BackendFS.ReadFile(Path)
    local Table = Binser.deserialize(Content)[1]
    Things.ClearRoot()

    Scenes.Objects.DeserializeObjects(Table)
end

return Scenes