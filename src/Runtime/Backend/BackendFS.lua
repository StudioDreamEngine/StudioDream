local BackendFS = {}
local Mount

function BackendFS.OpenFile(Path, Mode)
    return love.filesystem.openNativeFile(Mount..Path, Mode)
end

function BackendFS.GetFullPath(FilePath)
    return Mount..FilePath.FilePath
end

function BackendFS.WriteFile(Path, Data)
    local File = BackendFS.OpenFile(Path, "w")
    File:write(Data)
    File:close()
end

function BackendFS.FileExists(Path)
    return NativeFS.getInfo(Mount..Path)
end

function BackendFS.ListDirectory(Path)
    return NativeFS.getDirectoryItems(Mount..(Path or ""))
end

function BackendFS.CreateDirectory(Path)
    print(NativeFS.getInfo(Mount..Path))

    NativeFS.createDirectory(Mount..Path)
end

function BackendFS.ReadFile(Path)
    local File = BackendFS.OpenFile(Path, "r")
    local FileData = File:read()
    File:close()

    return FileData
end

function BackendFS.GetMount()
    return Mount
end

function BackendFS.MountProject(Project)--, MountZip)
    Mount = Project.."/"    
end

return BackendFS