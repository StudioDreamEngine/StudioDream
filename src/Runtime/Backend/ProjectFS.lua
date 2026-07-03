local ProjectFS = {}
local Mount

function ProjectFS.OpenFile(Path, Mode)
    return love.filesystem.openNativeFile(Mount..Path, Mode)
end

function ProjectFS.GetFullPath(FilePath)
    return Mount..FilePath.FilePath
end

function ProjectFS.WriteFile(Path, Data)
    local File = ProjectFS.OpenFile(Path, "w")
    print(File)
    File:write(Data)
    File:close()
end

function ProjectFS.FileExists(Path)
    return NativeFS.getInfo(Mount..Path)
end

function ProjectFS.ListDirectory(Path)
    return NativeFS.getDirectoryItems(Mount..(Path or ""))
end

function ProjectFS.CreateDirectory(Path)
    print(NativeFS.getInfo(Mount..Path))

    NativeFS.createDirectory(Mount..Path)
end

function ProjectFS.ReadFile(Path)
    if ProjectFS.FileExists(Path) then
        local File = ProjectFS.OpenFile(Path, "r")
        local FileData = File:read()
        File:close()

        return FileData
    end
end

function ProjectFS.GetMount()
    return Mount
end

function ProjectFS.UnmountProject()
    Mount = nil
end

function ProjectFS.MountProject(Project)
    local FullPath = NativeFS.getFullPath(Project)
    local LastChar = FullPath[#FullPath]
    
    if LastChar ~= "/" or LastChar ~= "\\" then
        if love.system.getOS() == Enum.Platform.Windows then
            FullPath = NativeFS.getFullPath(Project).."\\"
        else
            FullPath = NativeFS.getFullPath(Project).."/"
        end
    end

    print("Formatted Mount Point: "..FullPath)

    Mount = FullPath
end

return ProjectFS