local function UnixCopy(Source, Target)
    os.execute("cp -r "..Source.." "..Target)
end

local function lovefs_copy(Target, Info)
    for _, File in pairs(Info.Files) do
        NativeFS.write(Target..File, love.filesystem.read(File))
    end


end

-- lets... not rm root :3
local Forbidden = {
    "",
    "/",
    "/*"
}

---@param ProjectFS MountFS
return function(ProjectFS, Info, BuildDirectory)
    -- 1. extract appimage, copy to temporary build folder, remove StudioDream, move appImageTool to save directory
    local ImageMount = Path.new(love.filesystem.getSourceBaseDirectory()).ParentPath

    UnixCopy(ImageMount.."/*", BuildDirectory.Exec)
    NativeFS.remove(BuildDirectory.Exec.."/bin/StudioDream")

    -- move appImageTool to save directory
    print(BuildDirectory.Exec)

    if (not BuildDirectory.Exec) or table.find(Forbidden, BuildDirectory.Exec) then
        Shared.QueueAbort("BUILD: exec path was a forbidden path name")
        return
    end

    local ToolPath = "appImageTool.AppImage"
    local Tool = NativeFS.read(BuildDirectory.Exec..ToolPath)
    love.filesystem.write(ToolPath, Tool or "")
    NativeFS.remove(BuildDirectory.Exec..ToolPath)

    -- 2. copy love project fs to build folder, (TODO: remove exclusions)

    lovefs_copy(BuildDirectory.Love, Info)

    -- 3. concat /bin/love with zipped project fs

    -- 4. Configure appimage with icon and name

    -- 5. Build appimage
end