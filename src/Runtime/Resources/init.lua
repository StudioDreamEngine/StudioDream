local Resources = {}

local LoaderModPath = "Runtime.Resources.Loaders."
local Identifiers, LoadedResources

local FormatLookup = require("Runtime.Resources.FormatLookup")

function Resources.RegisterIdentifier(Identifier, FilePath) Identifiers[Identifier] = Path.new(FilePath, Identifier) end

-- Get the identifier, which holds the file path itself, 
function Resources.GetIdentifier(IdentifierID) return Identifiers[IdentifierID] end

function Resources.ClearIdentifier() 
    Identifiers = {} 
    LoadedResources = {}
end

Resources.ClearIdentifier()

function Resources.LoadResource(FilePath)
    local Format = FormatLookup[FilePath.FileType]

    local LoaderModule = require(LoaderModPath..Format)
    local Resource = LoaderModule(Runtime.BackendFS.ReadFile(FilePath.FilePath))

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