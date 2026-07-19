---@diagnostic disable: cast-local-type
local ProjectFS = {}
local BaseFS = Runtime.BaseFS

local Mount = nil ---@class MountFS

function ProjectFS.GetFullPath(FilePath)
    return Mount.GetFullPath(FilePath)
end

function ProjectFS.WriteFile(Path, Data)
    Mount.WriteFile(Path, Data)
end

function ProjectFS.FileExists(Path)
    return Mount.FileExists(Path)
end

function ProjectFS.IsWritable()
    return not Mount.IsZip   
end

function ProjectFS.ListDirectory(Path)
    return Mount.ListDirectory(Path)
end

function ProjectFS.CreateDirectory(Path)
    print(NativeFS.getInfo(Mount..Path))

    Mount.CreateDirectory(Path)
end

function ProjectFS.ReadFile(Path)
    return Mount.ReadFile(Path)
end

function ProjectFS.GetMount()
    return Mount.GetMount()
end

function ProjectFS.UnmountProject()
    Mount.Unmount()
    Mount = nil
end

function ProjectFS.MountProject(Project)
    Mount = BaseFS.Mount(Project)
    return Mount
end

return ProjectFS