local Resources = {}

local LoaderModPath = "Runtime.Resources.Loaders."
local Identifiers, LoadedResources

local FormatLookup = require("Runtime.Resources.FormatLookup")

function Resources.RegisterIdentifier(Identifier, FilePath) Identifiers[Identifier] = Path.new(FilePath, Identifier) end

-- sorta hack for studio assets
function Resources.GetStudioPath(IdentifierID)
    local PathSplit = string.split(IdentifierID, "/")

    if PathSplit[1] == "Internal" then
        PathSplit = table.concat(PathSplit, "/", 2)

        local InternalPath = Path.new(PathSplit, IdentifierID)
        InternalPath.Internal = true
    
        return InternalPath
    end
end

-- Get the identifier, which holds the file path itself, 
function Resources.GetIdentifier(IdentifierID) 
    return Resources.GetStudioPath(IdentifierID) or Identifiers[IdentifierID] 
end

function Resources.ClearIdentifier() 
    Identifiers = {} 
    LoadedResources = {}
end

Resources.ClearIdentifier()

function Resources.LoadResource(FilePath)
    local Format = FormatLookup[FilePath.FileType]

    local LoaderModule = require(LoaderModPath..Format)
    local Contents

    if FilePath.Internal then
        Contents = love.filesystem.read("Assets/"..FilePath.FilePath)
    else
        Contents = Runtime.BackendFS.ReadFile(FilePath.FilePath)
    end

    local Resource = LoaderModule(Contents)

    LoadedResources[FilePath.Identifier] = Resource
end

function Resources.GetResource(Identifier)
    if not LoadedResources[Identifier.Identifier] then
        Resources.LoadResource(Identifier)
    end

    return LoadedResources[Identifier.Identifier]
end

function Resources.UnloadResource(Identifier)
    print("TODO")
end

return Resources