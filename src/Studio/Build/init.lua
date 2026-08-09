-- Build a project (Studio only)
local Build = {}

-- Folders to remove from the build version of a project
local Exclusions = {
    "/Assets/Studio",
}

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

function Build.BuildProject()
    local TargetBuild = Platform.IsWindows and "Windows" or "Linux"

    if (not love.filesystem.isFused()) then
        print("Can only build projects in fused mode.")
        return
    end

    love.filesystem.createDirectory("build")

    local Info = {
        Exclusions = Exclusions,
        Directories = LoveDirectories,
        Files = LoveFiles
    }

    Targets[TargetBuild](Runtime.Project.Package(), Info, Platform.ParsePath(love.filesystem.getSaveDirectory().."/build"))
end

return Build