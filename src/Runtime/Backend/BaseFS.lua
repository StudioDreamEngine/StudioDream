local BaseFS = {}

---@return MountFS|nil
function BaseFS.Mount(PathString, MountName, IsLocal)
    ---@class MountFS
    local MountObject = {}
    local Path = Path.new(Platform.ParsePath(PathString)) ---@class Path

    MountObject.ReadOnly = IsLocal or (Path.FileType ~= nil)
    MountObject.MountPath = Path

    MountObject.QueueWrites = false
    MountObject.Writes = {}

    print("Attempting to mount new project: "..Path.FilePath)
    
    local WasMounted

    -- god
    if IsLocal then
        local Data = love.data.newByteData(love.filesystem.read(Path.FilePath))
        WasMounted = love.filesystem.mount(Data, Path.FilePath, MountName or "ProjectMount")
    else
        WasMounted = love.filesystem.mountFullPath(Path.FilePath, MountName or "ProjectMount")
    end

    if (not WasMounted) then print("Failed to mount") return end

    local MountDir = (MountName or "ProjectMount").."/"

    ---@param FilePath Identifier
    function MountObject.GetFullPath(FilePath)
        return Path.FilePath..FilePath
    end

    -- Create a directory at this mount point
    function MountObject.CreateDirectory(Path)
        if MountObject.ReadOnly then print("MountFS.CreateDirectory - Mount object is read only (zip)") end

        error("MountObject.CreateDirectory currently not tested! dont wanna fuck shit up if it doesnt work...")
        love.filesystem.createDirectory(MountDir..Path)
    end

    -- Get the mount path
    function MountObject.GetMount()
        return MountObject.MountPath.FilePath
    end

    -- Toggle if QueueWrite should Queue Writes or directly write
    function MountObject.ToggleQueueWrites(Toggle)
        MountObject.QueueWrites = Toggle
    end

    -- Write a file or queue a file to be written
    function MountObject.QueueWrite(WritePath, Data)
        if MountObject.ReadOnly then print("MountFS.QueueWrite - Mount object is read only (zip)") end

        if MountObject.QueueWrites then
            MountObject.Writes[WritePath] = Data
        else
            NativeFS.write(Path.FilePath..WritePath, Data)
        end
    end

    -- Get queued writes and clear them
    function MountObject.GetWrites()
        local Writes = table.clone(MountObject.Writes)
        MountObject.Writes = {}

        return Writes
    end

    -- Apply queued writes to new path
    function MountObject.ApplyWrites(NewPath)
        NewPath = Platform.ParsePath(NewPath)

        for Path, Data in pairs(MountObject.Writes) do
            NativeFS.write(NewPath..Path, Data)
        end

        MountObject.Writes = {}
    end

    -- Check if a file exists
    function MountObject.FileExists(Path)
        return love.filesystem.getInfo(MountDir..Path)
    end

    -- List items in a directory
    function MountObject.ListDirectory(Path)
        return love.filesystem.getDirectoryItems(((MountDir..Path) or ""))
    end

    -- Read a file in the mount
    function MountObject.ReadFile(Path)
        if MountObject.FileExists(Path) then
            local Contents = love.filesystem.read(MountDir..Path)
            return Contents
        end
    end

    -- Unmount this mountobject and KILL it
    function MountObject.Unmount()
        print("Unmounting "..Path.FilePath)

        -- man
        if (not IsLocal) then
            love.filesystem.unmountFullPath(Path.FilePath)
        else
            error("Cannot unmount local MountObject")
        end

        MountObject = {}
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