local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")
local Config = require("Runtime.Project.Configuration")

local ProjectFS = Runtime.ProjectFS
local RecentProjects = Runtime.SettingsManager.GetSetting("RecentProjects")

Project.RegisterRootScene = Scenes.RegisterRootScene
Project.LoadDefault = Scenes.LoadDefault
Project.GetConfig = Config.GetConfig
Project.SetConfig = Config.SetConfig
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
        Resources.Load()
        Config.Load()
        Runtime.ChangeTitle()

        Scenes.LoadRootScenes("Load")
        Runtime.LoadProjectCallback()
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
    local SaveProjectOn = ProjectPath
    if Platform.ParsePath(ProjectPath) == Platform.ParsePath(Platform.GetDocuments()) then
        NativeFS.createDirectory(Platform.ParsePath(ProjectPath)..Project.GetConfig("Name"))
        SaveProjectOn = Platform.ParsePath(ProjectPath)..Project.GetConfig("Name")
    end

    ProjectFS.MountProject(SaveProjectOn)
    Project.Save()
end

-- Save a project
function Project.Save()
    print("Saving Project...")
    print(debug.traceback())

    Studio.Layout.GetHandle("Notification").Notify("Saving Project...","Info")

    if not ProjectFS.GetMount() then 
        Shared.QueueAbort("Abort save, no project found")
        Studio.Layout.GetHandle("Notification").Notify("Abort save, no project found","Error")
    else
        Config.Save()
        ProjectFS.WriteFile("Thumbnail.png", Dream:renderThumbnail())
        Scenes.LoadRootScenes("Save")
        Project.AddToHistory(ProjectFS.GetMount(), Project.GetConfig("Name"))
        Studio.Layout.GetHandle("Notification").Notify("Save Completed!","Info")
    end
end

return Project