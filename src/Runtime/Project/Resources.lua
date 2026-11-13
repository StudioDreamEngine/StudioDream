local Resources = {}
local ProjectFS = Runtime.ProjectFS

local FormatLookup = require("Runtime.Resources.FormatLookup")
local WhitelistedTypes = Utils.Keys(FormatLookup)

-- Go through the project and register all the resources in the project as identifiers
local function RecurseProject(Path, Mount, Callback)
    for _, v in pairs(Mount.ListDirectory(Path)) do
        local FileType = string.split(v, "%.")
        local IsDirectory = #FileType < 2 -- Dumb hack
        FileType = FileType[#FileType]

        local FilePath = Path..v

        if table.find(WhitelistedTypes, FileType) or IsDirectory then
            Callback(FilePath, Mount)
        end
    end
end

local Lookup = {}

local function HandleIdentifier(FilePath, Mount)
    local HasFile = Mount.FileExists(FilePath)

    if HasFile and HasFile.type == "directory" then
        RecurseProject(FilePath.."/", Mount, HandleIdentifier)
    elseif HasFile then
        local HasIdentifier = Mount.FileExists(FilePath .. ".uid")
        if not HasIdentifier then return end

        local IdentifierID = Mount.ReadFile(FilePath .. ".uid")

        Lookup[IdentifierID] = FilePath
    end
end

function Resources.GetIdentifers(Mount)
    Lookup = {}
    HandleIdentifier("", Mount)

    return Lookup
end

-- TODO: Replace with GetIdentifers
function Resources.HandleIdentifier(FilePath, _)
    local _, IsDirectory = Runtime.Resources.LoadOrCreateIdentifier(FilePath)

    if IsDirectory then
        printVerbose("Branching to directory:",FilePath)
        RecurseProject(FilePath.."/", ProjectFS, Resources.HandleIdentifier)
    end
end

-- Besides scenes in the future perhaps, nothing is needed here for now
function Resources.Save()
    Runtime.Resources.SaveResources()
end

function Resources.Load() 
    RecurseProject("", ProjectFS, Resources.HandleIdentifier)
end

return Resources