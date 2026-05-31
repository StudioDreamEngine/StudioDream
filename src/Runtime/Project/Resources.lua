local Resources = {}
local BackendFS = Runtime.BackendFS

local BlacklistedTypes = {"uid", "sds", "sdrm"} -- sds is here for now

local function RecurseProject(Path)
    for _, v in pairs(BackendFS.ListDirectory(Path)) do
        local FileType = string.split(v, "%.")[2]
        local FilePath = Path..string.split(v, "%.")[1]

        if not table.find(BlacklistedTypes, FileType) then
            Resources.HandleIdentifier(FilePath, FileType)
        end
    end
end

function Resources.HandleIdentifier(FilePath, FileType)
    local HasIdentifier = BackendFS.FileExists(FilePath..".uid")
    local Identifier

    if (not HasIdentifier) then -- Create a new identifier
        Identifier = CreateUUID()
        BackendFS.WriteFile(FilePath..".uid", Identifier)
    else
        Identifier = BackendFS.ReadFile(FilePath..".uid")

        if HasIdentifier.type == "directory" then
            print(FilePath)
            RecurseProject(FilePath)
        end
    end

    Runtime.Resources.RegisterIdentifier(Identifier, FilePath.."."..FileType)
end

-- Besides scenes in the future perhaps, nothing is needed here for now
function Resources.Save() end
function Resources.Load() RecurseProject("") end

return Resources