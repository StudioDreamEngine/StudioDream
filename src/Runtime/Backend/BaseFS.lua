local BaseFS = {}

function BaseFS.OpenFile(Path, Mode)
    return love.filesystem.openNativeFile(Path, Mode)
end

function BaseFS.WriteFile(Path, Data)
    local File = BaseFS.OpenFile(Path, "w")
    print(File)
    File:write(Data)
    File:close()
end

function BaseFS.FileExists(Path)
    return NativeFS.getInfo(Path)
end

function BaseFS.ListDirectory(Path)
    return NativeFS.getDirectoryItems((Path or ""))
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