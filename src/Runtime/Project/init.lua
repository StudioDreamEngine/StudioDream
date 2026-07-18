local Project = {}
local Scenes = require("Runtime.Project.Scenes")
local Resources = require("Runtime.Project.Resources")

local ProjectFS = Runtime.ProjectFS

Project.History = require("Runtime.Project.History")
Project.Config = require("Runtime.Project.Configuration")

Project.RegisterRootScene = Scenes.RegisterRootScene
Project.LoadDefault = Scenes.LoadDefault

Project.NotificationCallback = function(Message, Type) print(Message, Type) end

Project.LoadingProject = false

Project.LoadedProject = Signal:New("WhenAnActualProjectIsLoaded")

-- Make sure a project path is a valid project
function Project.ValidateAndMount(ProjectPath)
    assert(ProjectPath, "ProjectPath was blank!")

    if (not NativeFS.getInfo(ProjectPath)) then
        Project.History.Remove(ProjectPath)
        return Shared.QueueAbort("Failed to load Project: "..ProjectPath)
    end

    ProjectFS.MountProject(ProjectPath)

    if not ProjectFS.FileExists("Project.sdc") then
        ProjectFS.UnmountProject()
        return Shared.QueueAbort("Project.sdc not found in specified project path, are you sure it's a valid StudioDream project?")
    end
end

local DefaultImage = Runtime.Resources.GetIdentifierFromID("Internal/Studio/Update_Thumbs/Early_Riser.png")

function Project.GetSummary(ProjectPath)
    local BaseFS = Runtime.BaseFS
    
    if (not Runtime.BaseFS.FileExists(ProjectPath)) then
        return {
            Config = Project.Config.GetDefault(),
            ImageResource = DefaultImage 
        }
    end

    ProjectPath = Platform.ParsePath(ProjectPath)

    if (not BaseFS.FileExists(ProjectPath.."Project.sdc")) then
        return {
            Config = Project.Config.GetDefault(),
            ImageResource = DefaultImage 
        }
    end

    local Config = Project.Config.Load(ProjectPath)

    local ImageData = BaseFS.ReadFile(ProjectPath.."Thumbnail.png")
    local Image = ImageData and Runtime.Resources.InitiateLoader("Image", ImageData) or DefaultImage

    return {
        Config = Config,
        ImageResource = Runtime.Resources.GetIdentifierFromID(Image)
    }
end

function Project.EditName(NewName)
    local ProjectDirectory = ProjectFS.GetMount()
    local NewDirectoryName = Platform.GetDocuments().."/"..NewName
    Project.Config.Set("Name",NewName)
    local Success,Err = os.rename(ProjectDirectory,NewDirectoryName)

    if Success then
        Project.History.Remove(ProjectDirectory)
        Project.History.Add(NewDirectoryName, Project.Config.Get("Name"))
        Runtime.ChangeTitle()
        return true
    else
        return false
    end
end

function Project.Load(ProjectPath)
    local WasInvalid = Project.ValidateAndMount(ProjectPath)
    if WasInvalid then return end

    Project.LoadingProject = true
    local LoadProject = Profiler.Benchmark("Load Project")
    
    local Success, Message = pcall(function()
        Resources.Load()
        Project.Config.Load()
        Runtime.ChangeTitle()

        Scenes.LoadRootScenes("Load")
        Runtime.LoadProjectCallback()
    end)

    LoadProject.End()
    Project.LoadingProject = false

    if (not Success) then
        print(Message)
        Shared.QueueAbort("Error while loading project: "..ProjectPath)
    else
        Project.LoadedProject.Invoke()
        Project.History.Add(ProjectFS.GetMount(), Project.Config.Get("Name"))
    end
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    --[[local SaveProjectOn = ProjectPath
    
    if Platform.ParsePath(ProjectPath) == Platform.ParsePath(Platform.GetDocuments()) then
        NativeFS.createDirectory(Platform.ParsePath(ProjectPath)..Project.Config.Get("Name"))
        SaveProjectOn = Platform.ParsePath(ProjectPath)..Project.Config.Get("Name")
    end]] -- we dont need this

    ProjectFS.MountProject(ProjectPath)
    Project.Save()
end

-- Save a project
function Project.Save()
    Project.NotificationCallback("Saving project...")

    if not ProjectFS.GetMount() then 
        Project.NotificationCallback("Please first load a project first in order to save", "Error")
    else
        Project.Config.Save()
        ProjectFS.WriteFile("Thumbnail.png", Dream:renderThumbnail())
        Scenes.LoadRootScenes("Save")

        Project.History.Add(ProjectFS.GetMount(), Project.Config.Get("Name"))

        Project.NotificationCallback("Project saved!")
    end
end

return Project
