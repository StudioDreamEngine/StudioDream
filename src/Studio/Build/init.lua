-- Build a project (Studio only)
local Build = {}

local LoveDirectories = {
    "Runtime",
    "Client",
    "Shared",
    "Assets",
    --"CLibraries",
}

local LoveFiles = {
    "conf.lua",
    "main.lua",
    --"flags.lua"
}

local Targets = {
    Windows = require("Studio.Build.Windows"),
    Linux = require("Studio.Build.Linux")
}

---@param TargetZip LoveZip
local function lovefs_copy(TargetZip)
    for _, File in pairs(LoveFiles) do
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

    for _, Directory in pairs(LoveDirectories) do
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

function Build.BuildProject()
    local TargetBuild = Platform.IsWindows and "Windows" or "Linux"

    if (not love.filesystem.isFused()) then
        print("Can only build projects in fused mode.")
        return
    end

    love.filesystem.remove("build")
    love.filesystem.createDirectory("build")

    local BuildDirectory = Platform.ParsePath(love.filesystem.getSaveDirectory().."/build")

    if (not BuildDirectory) or table.find(Forbidden, BuildDirectory) then
        Shared.QueueAbort("BUILD: exec path was a forbidden path name")
        return
    end

    ---@class DialogProgress
    Progress = Studio.Components.CreateDialog(Enum.StudioDialog.Progress)
    Progress.SetStages(2)

    -- 1. Package LoveFS + Project
    Progress.NextStage("Packaging LoveFS + Project")
    local Zip = love.zip:newZip() ---@class LoveZip
    local ProjectZip = Runtime.Project.Package()

    Progress.SetSubStages(#LoveDirectories)
    lovefs_copy(Zip)

    -- 2. Configure love fs, Finish zip
    Progress.NextStage("Configuring Love FS")
    Progress.SetSubStages(2)
    Progress.NextSubstage()

    -- Configure flags
    local CurrentFlags = table.clone(FLAGS)
    CurrentFlags.Target = "Client"
    CurrentFlags.TargetProject = "(ignored)"
    CurrentFlags.SecondRun = true
    CurrentFlags.Independent = true

    Zip:_add("project.sdp", ProjectZip)
    Zip:_add("flags.lua", "return "..table.format(CurrentFlags))

    local ZipBytes = Zip:finish()

    Targets[TargetBuild](Progress, ZipBytes, BuildDirectory)

    Progress.Close()
    Studio.Components.SimpleDialog("Project has been built!") -- TODO: Use notifs
end

return Build