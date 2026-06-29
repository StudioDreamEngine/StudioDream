local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")

local BackendFS = Runtime.BackendFS
local RecentProjects = Runtime.SettingsManager.GetSetting("RecentProjects")

Project.SerializeType = Scenes.Objects.HandleType
Project.ProjectName = "Unnamed"

function Project.ValidateAndMount(ProjectPath)
    if (not NativeFS.getInfo(ProjectPath)) then
        Shared.QueueAbort("Couldnt load project: "..ProjectPath)
        return true
    end

    BackendFS.MountProject(ProjectPath)

    if not BackendFS.FileExists("MainScene.sds") then
        Shared.QueueAbort("MainScene.sds wasnt found in specified project path, are you sure it was a valid StudioDream project?")
        BackendFS.UnmountProject()
        return true
    end
end

function Project.AddToHistory(Path, Name)
    RecentProjects[Path] = {
        Name = Name,
        Time = os.time()
    }

    Runtime.SettingsManager.ChangeSetting("RecentProjects", RecentProjects)

    print(RecentProjects)
end

function Project.LoadDefault()
    local Camera = Runtime.Things.Create("Camera") {
        
    }
end

function Project.Load(ProjectPath)
    local WasInvalid = Project.ValidateAndMount(ProjectPath)
    if WasInvalid then return end

    local Success, Message = pcall(function()
        Runtime.LoadProjectCallback()
        
        Resources.Load()
        Runtime.ChangeTitle()

        Scenes.LoadScene("Materials.sds", Runtime.Things.GetRoot("Materials"))
        Scenes.LoadScene("MainScene.sds", Runtime.Things.GetRoot("Environment"))
        Scenes.LoadScene("Interface.sds", Runtime.Things.GetRoot("HUD"))
    end)

    if (not Success) then
        print(Message)
        Shared.QueueAbort("Error while loading project: "..ProjectPath)
    else
        Project.AddToHistory(BackendFS.GetMount(), Project.ProjectName)
    end
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    BackendFS.MountProject(ProjectPath)

    Project.Save()
end

function Project.Save()
    print("Saving Project...")
    if not BackendFS.GetMount() then 
        Shared.QueueAbort("Abort save, no project found")
        return 
    end

    -- Once we have several scenes, sdrm should just store the configuration
    Scenes.SaveScene("Interface.sds", Runtime.Things.GetRoot("HUD"))
    Scenes.SaveScene("MainScene.sds", Runtime.Things.GetRoot("Environment"))
    Scenes.SaveScene("Materials.sds", Runtime.Things.GetRoot("Materials"))
end

return Project