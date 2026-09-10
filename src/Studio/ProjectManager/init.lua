-- Handles the opening and saving of a project
local ProjectManager = {}
local RuntimeService = Runtime.Services.Service("RuntimeService") ---@class RuntimeService

local History = require("Studio.ProjectManager.History")

ProjectManager.AlreadyRunning = false

Runtime.Project.NotificationCallback = function(Message, Type)
    Studio.Layout.GetHandle("Notification").Notify(Message,Type or "Info")
end

function ProjectManager.AddHistory()
    History.Add(Runtime.ProjectFS, Runtime.Project.Config.Get("Name"))
end

function ProjectManager.RemoveHistory(Path)
    History.Remove(Path)
end

-- Load a project
function ProjectManager.LoadProject(Callback)
    Platform.OpenWithCallback("Load Project (sdc or sdp)", Enum.OpenDialog.File, function(ProjectPath)
        local Success = Runtime.Project.Load(ProjectPath)
        if Callback then Callback() end

        if Success then
            ProjectManager.AddHistory()
        else
            ProjectManager.RemoveHistory(ProjectPath)
        end
    end)
end

-- Save the project to a new directory
function ProjectManager.SaveProjectTo(Callback)
    Platform.OpenWithCallback("Save Project", Enum.OpenDialog.Folder, function(ProjectPath)
        Runtime.Project.SaveTo(ProjectPath)
        if Callback then Callback() end

        Utils.Warn("Please note that resources currently do not transfer between")
    end)
end

function ProjectManager.RunStudioProject()
    if ProjectManager.AlreadyRunning then return end

    --Runtime.Project.SaveTo("")
    Runtime.Project.Save()
    Studio.EditorUI.Playtest.StartPlayline()
    RuntimeService.StartActivity()

    ProjectManager.AlreadyRunning = true
end

function ProjectManager.StopStudioProject()
    if not ProjectManager.AlreadyRunning then return end
    
    Runtime.RequestRestart("Studio")

    --[[Studio.Editor3D.SelectionManager.DeselectAll()
    Studio.EditorUI.Playtest.EndPlayline()
    Studio.History.Clear()
    RuntimeService.Stop()
    
    ProjectManager.AlreadyRunning = false]]
end

function ProjectManager.SaveProject()
    local Success = Runtime.Project.Save()

    if Success then
        ProjectManager.AddHistory()
    end
end

function ProjectManager.PackageProject()
    Runtime.Project.Export()
end

function ProjectManager.NewProject(Name)
    local Directory = Platform.GetDocuments().."/"..Platform.PathFriendly(Name)
    
    Runtime.Project.CreateProject(Directory)
    Runtime.Project.Config.Set("Name",Name)
    Runtime.Project.Config.Set("WindowResize",true)
    --Runtime.Project.Config.Set("Icon","Internal/Icons/Client.png")
end

return ProjectManager