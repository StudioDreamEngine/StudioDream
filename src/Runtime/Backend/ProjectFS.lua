---@diagnostic disable: cast-local-type
local ProjectFS = {}
local BaseFS = Runtime.BaseFS

local Mount = nil ---@class MountFS

-- Writing Wrappers
function ProjectFS.QueueWrite(Path, Data) Mount.QueueWrite(Path, Data) end
function ProjectFS.GetWrites() return Mount.GetWrites() end
function ProjectFS.ApplyWrites(Path) return Mount.ApplyWrites(Path) end
function ProjectFS.ToggleQueueWrites(Toggle) Mount.ToggleQueueWrites(Toggle) end
function ProjectFS.IsQueuingWrites() return Mount.QueueWrites end

-- General
function ProjectFS.FileExists(Path) return Mount.FileExists(Path) end
function ProjectFS.IsWritable() return not Mount.IsZip    end
function ProjectFS.ListDirectory(Path) return Mount.ListDirectory(Path) end
function ProjectFS.GetFullPath(FilePath) return Mount.GetFullPath(FilePath) end

-- File and Directory general
function ProjectFS.CreateDirectory(Path)
    print(NativeFS.getInfo(Mount..Path))
    Mount.CreateDirectory(Path)
end

function ProjectFS.ReadFile(Path) return Mount.ReadFile(Path) end

-- Mounting wrappers
function ProjectFS.GetMount() return Mount.GetMount() end
function ProjectFS.MountProject(Project) Mount = BaseFS.Mount(Project); return Mount end
function ProjectFS.UnmountProject() Mount.Unmount(); Mount = nil end
function ProjectFS.Remount(Path) Mount.Unmount(); return ProjectFS.MountProject(Path) end

return ProjectFS