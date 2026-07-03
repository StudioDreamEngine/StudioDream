local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")
local Config = require("Runtime.Project.Configuration")

local ProjectFS = Runtime.ProjectFS
local RecentProjects = Runtime.SettingsManager.GetSetting("RecentProjects")

Project.SerializeType = Scenes.Objects.HandleType
Project.RegisterRootScene = Scenes.RegisterRootScene
Project.LoadDefault = Scenes.LoadDefault
Project.GetConfig = Config.GetConfig

-- Make sure a project path is a valid project
function Project.ValidateAndMount(ProjectPath)
    if (not ProjectPath) then
        return Shared.QueueAbort("ProjectPath was blank! This is a BUG... get bloctans!")
    end

    if (not NativeFS.getInfo(ProjectPath)) then
        return Shared.QueueAbort("Couldnt load project: "..ProjectPath)
    end

    ProjectFS.MountProject(ProjectPath)

    if not ProjectFS.FileExists("Project.sdc") then
        ProjectFS.UnmountProject()
        return Shared.QueueAbort("Project.sdc wasnt found in specified project path, are you sure it was a valid StudioDream project?")
    end
end

function Project.AddToHistory(Path, Name)
    RecentProjects[Path] = {
        Name = Name,
        Time = os.time()
    }

    Runtime.SettingsManager.ChangeSetting("RecentProjects", RecentProjects)
    printVerbose(RecentProjects)
end

function Project.Load(ProjectPath)
    local WasInvalid = Project.ValidateAndMount(ProjectPath)
    if WasInvalid then return end

    local LoadProject = Profiler.Benchmark("Load Project")
    
    local Success, Message = pcall(function()
        Runtime.LoadProjectCallback()
        
        Resources.Load()
        Config.Load()
        Runtime.ChangeTitle()

        Scenes.LoadRootScenes("Load")
    end)

    LoadProject.End()

    if (not Success) then
        print(Message)
        Shared.QueueAbort("Error while loading project: "..ProjectPath)
    else
        Project.AddToHistory(ProjectFS.GetMount(), Project.GetConfig("Name"))
    end
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    ProjectFS.MountProject(ProjectPath)
    Project.Save()
end

-- Save a project
function Project.Save()
    print("Saving Project...")

    if not ProjectFS.GetMount() then 
        Shared.QueueAbort("Abort save, no project found")
    else
        Config.Save()
        Scenes.LoadRootScenes("Save")
    end
end

return Project