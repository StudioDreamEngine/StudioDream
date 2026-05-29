-- Handles the opening and saving of a project
local ProjectManager = {}

-- Load a project
function ProjectManager.LoadProject()
    FileDialog.OpenFolderDialog("Load Project")
end

-- Save the project to a new directory
function ProjectManager.SaveProjectTo()
    local SavePath = FileDialog.OpenFolderDialog("Save Project To")

    Runtime.Project.SaveTo(SavePath)
end

return ProjectManager