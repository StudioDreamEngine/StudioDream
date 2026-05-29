local BackendFS = {}
local Mount

function BackendFS.OpenFile(Path, Mode)
    return love.filesystem.openNativeFile(Mount..Path, Mode)
end

function BackendFS.WriteFile(Path, Data)
    local File = BackendFS.OpenFile(Path, "w")
    File:write(Data)
    File:close()
end

function BackendFS.ReadFile(Path)
    local File = BackendFS.OpenFile(Path, "r")
    local FileData = File:read()
    File:close()

    return FileData
end

function BackendFS.MountProject(Project)--, MountZip)
    Mount = Project.."/"
end

return BackendFS