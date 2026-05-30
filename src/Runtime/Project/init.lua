local Project = {}
local Serializer = require("Runtime.Project.Serializer")
local Resources = require("Runtime.Project.Resources")

local BackendFS = Runtime.BackendFS

function Project.Load(ProjectPath)
    BackendFS.MountProject(ProjectPath)
    Resources.Load()

    local File = BackendFS.ReadFile("project.sdrm")
    Serializer.Deserialize(File)
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    BackendFS.MountProject(ProjectPath)

    Project.Save()
end

function Project.Save()
    -- Once we have several scenes, sdrm should just store the configuration
    local ProjectData = Serializer.Serialize(Runtime.Things.Root)
    BackendFS.WriteFile("project.sdrm", ProjectData)
end

return Project