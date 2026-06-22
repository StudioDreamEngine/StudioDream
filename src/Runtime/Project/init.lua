local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")

local BackendFS = Runtime.BackendFS

Project.SerializeType = Scenes.Objects.HandleType
Project.ProjectName = "Unnamed"

function Project.Load(ProjectPath)
    print(ProjectPath)

    if (not NativeFS.getInfo(ProjectPath)) then
        Shared.Abort("Couldnt load project: "..ProjectPath)
    end

    BackendFS.MountProject(ProjectPath)
    Runtime.LoadProjectCallback()
    
    Resources.Load()
    Runtime.ChangeTitle()

    Scenes.LoadScene("MainScene.sds", Runtime.Things.GetRoot("Environment"))
    Scenes.LoadScene("Interface.sds", Runtime.Things.GetRoot("HUD"))
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    BackendFS.MountProject(ProjectPath)

    Project.Save()
end

function Project.Save()
    print("Saving Project...")

    -- Once we have several scenes, sdrm should just store the configuration
    Scenes.SaveScene("MainScene.sds", Runtime.Things.GetRoot("Environment"))
    Scenes.SaveScene("Interface.sds", Runtime.Things.GetRoot("HUD"))
end

return Project