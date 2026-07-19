local History = {}

local RecentProjects = Runtime.SettingsManager.GetSetting("Projects")

function History.Clear()
    RecentProjects = {}
end

function History.Remove(Path)
    print("Removing "..Path.." from project history")
    RecentProjects[Path] = nil

    Runtime.SettingsManager.ChangeSetting("Projects", RecentProjects)
    printVerbose(RecentProjects)
end

function History.Add(Path, Name)
    RecentProjects[Path] = {
        Name = Name,
        Time = os.time()
    }

    Runtime.SettingsManager.ChangeSetting("Projects", RecentProjects)
    printVerbose(RecentProjects)
end

return History