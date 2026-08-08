-- Build a project (Studio only)
local Build = {}

-- Folders to remove from the build version of a project
local Exclusions = {
    "./Assets/Studio",
    "./Studio"
}

local Targets = {
    Windows = require("Studio.Build.Windows"),
    Linux = require("Studio.Build.Linux")
}

function Build.BuildProject()
    local TargetBuild = Platform.IsWindows and "Windows" or "Linux"

    Targets[TargetBuild](Runtime.ProjectFS, Exclusions)
end

return Build