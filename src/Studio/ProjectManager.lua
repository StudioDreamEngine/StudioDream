-- Handles the opening and saving of a project
local ProjectManager = {}

-- Load a project
function ProjectManager.LoadProject()
    Platform.OpenWithCallback("Load Project", Enum.OpenDialog.Folder, Runtime.Project.Load)
end

-- Save the project to a new directory
function ProjectManager.SaveProjectTo()
    Platform.OpenWithCallback("Load Project", Enum.OpenDialog.Folder, Runtime.Project.SaveTo)
end

function ProjectManager.SaveProject()
    Runtime.Project.Save()
end

return ProjectManager