local Resources = {}
local ProjectFS = Runtime.ProjectFS

local FormatLookup = require("Runtime.Resources.FormatLookup")
local WhitelistedTypes = Utils.Keys(FormatLookup)

-- Go through the project and register all the resources in the project as identifiers
local function RecurseProject(Path)
    for _, v in pairs(ProjectFS.ListDirectory(Path)) do
        local FileType = string.split(v, "%.")
        local IsDirectory = #FileType < 2 -- Dumb hack
        FileType = FileType[#FileType]

        local FilePath = Path..v

        if table.find(WhitelistedTypes, FileType) or IsDirectory then
            Resources.HandleIdentifier(FilePath)
        end
    end
end

function Resources.HandleIdentifier(FilePath)
    local _, IsDirectory = Runtime.Resources.LoadOrCreateIdentifier(FilePath)

    if IsDirectory then
        printVerbose(FilePath)
        RecurseProject(FilePath.."/")
    end
end

-- Besides scenes in the future perhaps, nothing is needed here for now
function Resources.Save() end
function Resources.Load() RecurseProject("") end

return Resources