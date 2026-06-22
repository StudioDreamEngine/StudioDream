-- handle serialization of Simple binary Scenes
local Things = Runtime.Things
local Scenes = {}

local BackendFS = Runtime.BackendFS

Scenes.Objects = require("Runtime.Project.Scenes.Objects")

function Scenes.SaveScene(Path, Target)
    local ObjectTable = Scenes.Objects.SerializeObjects(Target)

    love.filesystem.write("TempLevel", table.format(ObjectTable))

    local Data = Binser.serialize(ObjectTable)
    BackendFS.WriteFile(Path, Data)
end

function Scenes.ConfigureTargetsTemp()
    ---@class Thing
    local Environment = Things.GetRoot("Environment")

    Environment.Camera = Environment:FindFirstChild("Camera")
end

function Scenes.LoadScene(Path, Target)
    if (not BackendFS.FileExists(Path)) then
        print("Scene "..Path.." Doesnt exist! Not loading scene...")
        return
    end

    print("Loading Scene: "..Path)

    local Content = BackendFS.ReadFile(Path)
    local Table = Binser.deserialize(Content)[1]

    Scenes.Objects.DeserializeObjects(Table, Target)
    Scenes.ConfigureTargetsTemp()
end

return Scenes