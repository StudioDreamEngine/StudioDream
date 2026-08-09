local function UnixCopy(Source, Target)
    os.execute("cp -r "..Source.." "..Target)
end

local Progress

---@param TargetZip LoveZip
local function lovefs_copy(TargetZip, Info)
    for _, File in pairs(Info.Files) do
        TargetZip:_add(File, love.filesystem.read(File))
    end

    local function CopyDirectory(Path, Target)
        for _, Name in pairs(love.filesystem.getDirectoryItems(Path)) do
            local FilePath = Path..Name
            local Info = love.filesystem.getInfo(FilePath)

            if Info.type == "directory" then
                CopyDirectory(FilePath.."/", Target)
            elseif Info.type == "file" then
                local Data = love.filesystem.read(FilePath)

                TargetZip:_add(FilePath, Data)
            end
        end
    end

    for _, Directory in pairs(Info.Directories) do
        Progress.NextSubstage()
        CopyDirectory(Directory.."/", TargetZip) 
    end
end

-- lets... not rm root :3
local Forbidden = {
    "",
    "/",
    "/*"
}

return function(ProjectZip, Info, BuildDirectory)
    ---@class DialogProgress
    Progress = Studio.Components.CreateDialog(Enum.StudioDialog.Progress)

    Progress.SetStages(6)

    -- 1. extract appimage, copy to temporary build folder, remove StudioDream, move appImageTool to save directory
    Progress.NextStage("Setting up AppImage FS...")
    local ImageMount = Path.new(love.filesystem.getSourceBaseDirectory()).ParentPath

    UnixCopy(ImageMount.."/*", BuildDirectory)
    NativeFS.remove(BuildDirectory.."/bin/StudioDream")

    -- move appImageTool to save directory

    if (not BuildDirectory) or table.find(Forbidden, BuildDirectory) then
        Shared.QueueAbort("BUILD: exec path was a forbidden path name")
        return
    end

    local ToolPath = "appImageTool.AppImage"
    local Tool = NativeFS.read(BuildDirectory..ToolPath)
    love.filesystem.write(ToolPath, Tool or "")
    NativeFS.remove(BuildDirectory..ToolPath)

    -- 2. copy love project fs to build folder, (TODO: remove exclusions)
    Progress.NextStage("Setting up Love FS...")
    local Zip = love.zip:newZip() ---@class LoveZip

    Progress.SetSubStages(#Info.Directories)
    lovefs_copy(Zip, Info)

    -- 3. Configure love fs, Finish zip
    Progress.NextStage("Configuring Love FS")
    Progress.SetSubStages(2)
    Progress.NextSubstage()

    -- Configure flags
    local CurrentFlags = table.clone(FLAGS)
    CurrentFlags.Target = "Client"
    CurrentFlags.TargetProject = "project.sdp"
    CurrentFlags.SecondRun = true
    CurrentFlags.Independent = true

    Zip:_add("project.sdp", ProjectZip)
    Zip:_add("flags.lua", "return "..table.format(CurrentFlags))

    -- Copy Libraries
    --[[Progress.NextSubstage()
    local CLibs = "CLibraries/Linux/"
    local LibraryPath = BuildDirectory.."/lib/studio-dream/"

    for _, Name in pairs(love.filesystem.getDirectoryItems(CLibs)) do
        NativeFS.write(LibraryPath..Name, love.filesystem.read(CLibs..Name))
    end]]

    -- Finish zip
    Progress.NextSubstage()
    local ZipBytes = Zip:finish()

    -- 4. concat /bin/love with zipped project file
    Progress.NextStage("Building Executable")

    local LovePath = BuildDirectory.."/bin/"
    local LoveBytes = NativeFS.read(LovePath.."love")

    local StudioDreamPath = LovePath.."StudioDream"

    NativeFS.remove(LovePath.."love")
    NativeFS.write(StudioDreamPath, LoveBytes..ZipBytes)

    os.execute("chmod +x "..StudioDreamPath)

    -- 5. Configure appimage with icon and name
    Progress.NextStage("Configuring AppImage")
    -- TODO

    -- 6. Build appimage
    Progress.NextStage("Building AppImage...")
    local SaveDir = love.filesystem.getSaveDirectory().."/"
    ToolPath = SaveDir..ToolPath

    local Command = ToolPath.." \""..BuildDirectory.."\" \""..(SaveDir.."Project.AppImage\"")
    --print(Command)

    os.execute("chmod +x "..ToolPath)
    os.execute(Command)

    Progress.Close()
    Studio.Components.SimpleDialog("Project has been built!") -- TODO: Use notifs
end