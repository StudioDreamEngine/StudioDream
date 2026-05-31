local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")

local BackendFS = Runtime.BackendFS

function Project.Load(ProjectPath)
    BackendFS.MountProject(ProjectPath)
    Resources.Load()

    --Scenes.LoadScene("MainScene.sds")
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    BackendFS.MountProject(ProjectPath)

    Project.Save()
end

function Project.Save()
    -- Once we have several scenes, sdrm should just store the configuration
    Scenes.SaveScene("MainScene.sds", Runtime.Things.GetRoot("Environment"))
end

return Project