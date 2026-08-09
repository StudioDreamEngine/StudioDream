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
        --NativeFS.createDirectory(Target..Path)

        for _, Name in pairs(love.filesystem.getDirectoryItems(Path)) do
            local FilePath = Path..Name
            local Info = love.filesystem.getInfo(FilePath)

            if Info.type == "directory" then
                CopyDirectory(FilePath.."/", Target)
            elseif Info.type == "file" then
                local Data = love.filesystem.read(FilePath)

                TargetZip:_add(FilePath, Data)
                --NativeFS.write(Target..FilePath, Data)
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

---@param ProjectFS MountFS
return function(ProjectFS, Info, BuildDirectory)
    ---@class DialogProgress
    Progress = Studio.Components.CreateDialog(Enum.StudioDialog.Progress)

    Progress.SetStages(6)

    -- 1. extract appimage, copy to temporary build folder, remove StudioDream, move appImageTool to save directory
    Progress.NextStage("Setting up AppImage FS...")
    local ImageMount = Path.new(love.filesystem.getSourceBaseDirectory()).ParentPath

    UnixCopy(ImageMount.."/*", BuildDirectory.Exec)
    NativeFS.remove(BuildDirectory.Exec.."/bin/StudioDream")

    -- move appImageTool to save directory

    if (not BuildDirectory.Exec) or table.find(Forbidden, BuildDirectory.Exec) then
        Shared.QueueAbort("BUILD: exec path was a forbidden path name")
        return
    end

    local ToolPath = "appImageTool.AppImage"
    local Tool = NativeFS.read(BuildDirectory.Exec..ToolPath)
    love.filesystem.write(ToolPath, Tool or "")
    NativeFS.remove(BuildDirectory.Exec..ToolPath)

    -- 2. copy love project fs to build folder, (TODO: remove exclusions)
    Progress.NextStage("Setting up Love FS...")
    local Zip = love.zip:newZip() ---@class LoveZip

    Progress.SetSubStages(#Info.Directories+1)
    lovefs_copy(Zip, Info)

    Progress.NextSubstage()
    local ZipBytes = Zip:finish()

    -- 3. Configure love fs
    Progress.NextStage("Configuring Love FS")

    

    -- 4. concat /bin/love with zipped project f

    -- 5. Configure appimage with icon and name

    -- 6. Build appimage
end