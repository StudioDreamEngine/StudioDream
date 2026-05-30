-- Handles the opening and saving of a project
local ProjectManager = {}

-- Load a project
function ProjectManager.LoadProject()
    local LoadPath = FileDialog.OpenFolderDialog("Load Project")

    Runtime.Project.Load(LoadPath)
end

-- Save the project to a new directory
function ProjectManager.SaveProjectTo()
    local SavePath = FileDialog.OpenFolderDialog("Save Project To")

    Runtime.Project.SaveTo(SavePath)
end

return ProjectManager