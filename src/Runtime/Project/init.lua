local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")

local BackendFS = Runtime.BackendFS

Project.SerializeType = Scenes.Objects.HandleType
Project.ProjectName = "Unnamed"

function Project.ValidateAndMount(ProjectPath)
    if (not NativeFS.getInfo(ProjectPath)) then
        Shared.Abort("Couldnt load project: "..ProjectPath)
        return true
    end

    BackendFS.MountProject(ProjectPath)

    if not BackendFS.FileExists("MainScene.sds") then
        Shared.Abort("MainScene.sds wasnt found in specified project path, are you sure it was a valid StudioDream project?")
        BackendFS.UnmountProject()
        return true
    end
end

function Project.Load(ProjectPath)
    local WasInvalid = Project.ValidateAndMount(ProjectPath)
    if WasInvalid then print("Aborting project load") return end

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
    Scenes.SaveScene("Interface.sds", Runtime.Things.GetRoot("HUD"))
    Scenes.SaveScene("MainScene.sds", Runtime.Things.GetRoot("Environment"))
end

return Project