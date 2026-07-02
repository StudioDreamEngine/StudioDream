-- Handles the opening and saving of a project
local ProjectManager = {}

-- Load a project
function ProjectManager.LoadProject(Callback)
    Platform.OpenWithCallback("Load Project", Enum.OpenDialog.Folder, function()
        Runtime.Project.Load()
        if Callback then Callback() end
    end)
end

-- Save the project to a new directory
function ProjectManager.SaveProjectTo(Callback)
     Platform.OpenWithCallback("Save Project", Enum.OpenDialog.Folder, function(ProjectPath)
        Runtime.Project.SaveTo(ProjectPath)
        if Callback then Callback() end
    end)
end

function ProjectManager.SaveProject()
    Runtime.Project.Save()
end

return ProjectManager