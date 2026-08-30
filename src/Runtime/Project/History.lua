local History = {}

local RecentProjects = Runtime.SettingsManager.Get("Projects")

function History.Clear()
    RecentProjects = {}
end

function History.Remove(Path)
    print("Removing "..Path.." from project history")
    RecentProjects[Path] = nil

    Runtime.SettingsManager.Set("Projects", RecentProjects)
    printVerbose(RecentProjects)
end

---@param Path MountFS
function History.Add(Path, Name)
    if Path.IsWritable() then
        RecentProjects[Path.GetMount()] = {
            Name = Name,
            Time = os.time()
        }

        Runtime.SettingsManager.Set("Projects", RecentProjects)
        printVerbose(RecentProjects)
    end
end

return History