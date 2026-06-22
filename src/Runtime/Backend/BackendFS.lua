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
    print(File)
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

function BackendFS.UnmountProject()
    Mount = nil
end

function BackendFS.MountProject(Project)
    local FullPath = NativeFS.getFullPath(Project)

    if love.system.getOS() ~= Enum.Platform.Windows then
        FullPath = NativeFS.getFullPath(Project).."/"
    end

    Mount = FullPath
end

return BackendFS