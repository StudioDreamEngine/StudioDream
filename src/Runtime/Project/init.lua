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

    ProjectPath = Platform.ParsePath(ProjectPath)

    print("ProjectPath:"..ProjectPath)
    local ProjectPath = Path.new(ProjectPath)
    local RealPath

    print(ProjectPath)

    if ProjectPath.FileType == "sdc" then -- Unpackaged project
        RealPath = ProjectPath.ParentPath
    elseif ProjectPath.FileType == "sdp" then -- Packaged project
        RealPath = ProjectPath.FilePath
    else
        return Shared.QueueAbort("Invalid file type for project")
    end

    local CouldMount = ProjectFS.MountProject(RealPath)

    if not CouldMount then
        return Shared.QueueAbort("Could not mount project, Are you sure it exists?")
    end
end

local DefaultImage = "Internal/Studio/Update_Thumbs/Early_Riser.png"



function Project.GetSummary(ProjectPath)
    local BaseFS = Runtime.BaseFS
    local Mount = BaseFS.Mount(ProjectPath, "Summary")

    if (not Mount) then
        Project.History.Remove(ProjectPath)
        return
    end

    if (not Mount.FileExists("Project.sdc")) then
        print("Project.sdc doesnt exist")
        Mount.Unmount()
        Project.History.Remove(ProjectPath)
        return
    end

    local Config = Project.Config.Load(Mount)

    local ImageData = Mount.ReadFile("Thumbnail.png")
    local Image = ImageData and Runtime.Resources.InitiateLoader("Image", ImageData) or DefaultImage

    Mount.Unmount()

    return {
        Config = Config,
        ImageResource = Runtime.Resources.GetIdentifierFromID(Image)
    }
end

function Project.EditName(NewName)
    -- Requires rewrite due to new MountFS system, not gonna do that rn tho
    --[[local ProjectDirectory = ProjectFS.GetMount()
    local NewDirectoryName = Platform.GetDocuments().."/"..NewName
    ProjectFS.SetMount(NewDirectoryName)
    Project.Config.Set("Name",NewName)
    local Success,Err = os.rename(ProjectDirectory,NewDirectoryName)

    if Success then
        Project.History.Remove(ProjectDirectory)
        Project.History.Add(ProjectFS, Project.Config.Get("Name"))
        Runtime.ChangeTitle()
        return true
    else
        return false
    end]]
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
        Project.History.Add(ProjectFS, Project.Config.Get("Name"))
    end
end

-- Remount to a new directory and save project
function Project.SaveTo(ProjectPath)
    print(ProjectPath)
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

        Project.History.Add(ProjectFS, Project.Config.Get("Name"))

        Project.NotificationCallback("Project saved!")
    end
end

return Project
