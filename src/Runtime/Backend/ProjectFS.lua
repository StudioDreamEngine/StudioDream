local ProjectFS = {}
local BaseFS = Runtime.BaseFS

local Mount

function ProjectFS.OpenFile(Path, Mode)
    return BaseFS.OpenFile(Mount..Path, Mode)
end

---@param FilePath Identifier
function ProjectFS.GetFullPath(FilePath)
    return Mount..FilePath.Data.FilePath
end

function ProjectFS.WriteFile(Path, Data)
    BaseFS.WriteFile(Mount..Path, Data)
end

function ProjectFS.FileExists(Path)
    return BaseFS.FileExists(Mount..Path)
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
    Mount = Platform.ParsePath(Project)
end

return ProjectFS