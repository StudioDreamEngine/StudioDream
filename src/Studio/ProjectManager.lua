-- Handles the opening and saving of a project
local ProjectManager = {}
local RuntimeService = Runtime.Services.Service("RuntimeService") ---@class RuntimeService

Runtime.Project.NotificationCallback = function(Message, Type)
    Studio.Layout.GetHandle("Notification").Notify(Message,Type or "Info")
end

-- Load a project
function ProjectManager.LoadProject(Callback)
    Platform.OpenWithCallback("Load Project (sdc or sdp)", Enum.OpenDialog.File, function(ProjectPath)
        Runtime.Project.Load(ProjectPath)
        if Callback then Callback() end
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
    Runtime.Project.Save()
    RuntimeService.StartActivity()
end

function ProjectManager.StopStudioProject()
    Studio.Editor3D.SelectionManager.DeselectAll()
    Studio.History.Clear()

    RuntimeService.Stop()
end

function ProjectManager.SaveProject()
    Runtime.Project.Save()
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