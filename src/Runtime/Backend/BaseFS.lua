local BaseFS = {}

---@return MountFS|nil
function BaseFS.Mount(PathString, MountName)
    ---@class MountFS
    local MountObject = {}
    local Path = Path.new(PathString) ---@class Path

    MountObject.IsZip = (Path.FileType ~= nil)
    MountObject.MountPath = Path

    print("Attempting to mount new project: "..Path.FilePath)
    
    local WasMounted = love.filesystem.mountFullPath(Path.FilePath, MountName or "ProjectMount")
    if (not WasMounted) then print("Failed to mount") return end

    local MountDir = (MountName or "ProjectMount").."/"

    ---@param FilePath Identifier
    function MountObject.GetFullPath(FilePath)
        return Path.FilePath..FilePath
    end

    function MountObject.CreateDirectory(Path)
        if MountObject.IsZip then print("MountFS.CreateDirectory - Mount object is read only as it is a zip") end

        error("MountObject.CreateDirectory currently not tested! dont wanna fuck shit up if it doesnt work...")
        love.filesystem.createDirectory(MountDir..Path)
    end

    function MountObject.GetMount()
        return MountObject.MountPath.FilePath
    end

    function MountObject.WriteFile(WritePath, Data)
        if MountObject.IsZip then print("MountFS.WriteFile - Mount object is read only as it is a zip") end

        NativeFS.write(Path.FilePath..WritePath, Data)
    end

    function MountObject.FileExists(Path)
        return love.filesystem.getInfo(MountDir..Path)
    end

    function MountObject.ListDirectory(Path)
        return love.filesystem.getDirectoryItems(((MountDir..Path) or ""))
    end

    function MountObject.ReadFile(Path)
        if MountObject.FileExists(Path) then
            local Contents = love.filesystem.read(MountDir..Path)
            return Contents
        end
    end

    function MountObject.Unmount()
        love.filesystem.unmountFullPath(Path.FilePath)
    end

    return MountObject
end

function BaseFS.FileExists(Path)
    return NativeFS.getInfo(Path)
end

function BaseFS.OpenFile(Path, Mode)
    return love.filesystem.openNativeFile(Path, Mode)
end

function BaseFS.ReadFile(Path)
    if BaseFS.FileExists(Path) then
        local File = BaseFS.OpenFile(Path, "r")
        local FileData = File:read()
        File:close()

        return FileData
    end
end

return BaseFS