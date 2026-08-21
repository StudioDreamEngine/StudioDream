local function UnixCopy(Source, Target)
    os.execute("cp -r "..Source.." "..Target)
end

return function(Progress, ZipBytes, BuildDirectory)
    Progress.SetStages(4)

    -- 1. extract appimage, copy to temporary build folder, remove StudioDream, move appImageTool to save directory
    Progress.NextStage("Setting up AppImage FS...")
    local ImageMount = Path.new(love.filesystem.getSourceBaseDirectory()).ParentPath

    UnixCopy(ImageMount.."/*", BuildDirectory)
    NativeFS.remove(BuildDirectory.."/bin/StudioDream")

    -- move appImageTool to save directory
    local ToolPath = "appImageTool.AppImage"
    local Tool = NativeFS.read(BuildDirectory..ToolPath)
    love.filesystem.write(ToolPath, Tool or "")
    NativeFS.remove(BuildDirectory..ToolPath)

    -- 2. concat /bin/love with zipped project file
    Progress.NextStage("Building Executable")

    local LovePath = BuildDirectory.."/bin/"
    local LoveBytes = NativeFS.read(LovePath.."love")

    local StudioDreamPath = LovePath.."StudioDream"

    NativeFS.remove(LovePath.."love")
    NativeFS.write(StudioDreamPath, LoveBytes..ZipBytes)

    os.execute("chmod +x "..StudioDreamPath)

    -- 3. Configure appimage with icon and name
    Progress.NextStage("Configuring AppImage")
    -- TODO

    -- 4. Build appimage
    Progress.NextStage("Building AppImage...")
    local SaveDir = love.filesystem.getSaveDirectory().."/"
    ToolPath = SaveDir..ToolPath

    local Command = ToolPath.." \""..BuildDirectory.."\" \""..(SaveDir.."Project.AppImage\"")
    --print(Command)

    os.execute("chmod +x "..ToolPath)
    os.execute(Command)
end