local Resources = {}

local LoaderModPath = "Runtime.Resources.Loaders."
local Identifiers, LoadedResources

local ObjectReferences = {}

local FormatLookup = require("Runtime.Resources.FormatLookup")

function Resources.RegisterIdentifierFromFile(FilePath, FileType)
    local BackendFS = Runtime.BackendFS

    local HasIdentifier = BackendFS.FileExists(FilePath..".uid")
    local HasFile = BackendFS.FileExists(FilePath.."."..FileType)

    if (not HasFile) then
        Runtime.BackendFS.WriteFile(FilePath.."."..FileType, "")
    end
    
    local Identifier

    if (not HasIdentifier) then -- Create a new identifier
        Identifier = CreateUUID()
        BackendFS.WriteFile(FilePath..".uid", Identifier)
    else
        Identifier = BackendFS.ReadFile(FilePath..".uid")
    end

    Resources.RegisterIdentifier(Identifier, FilePath.."."..FileType)

    return Identifier, HasIdentifier
end

function Resources.RegisterIdentifier(Identifier, FilePath) Identifiers[Identifier] = Path.new(FilePath, Identifier) end

function Resources.RegisterMissing(FilePath)
    print(FilePath.Identifier.." is missing! old path: "..FilePath.FilePath)

    table.insert(Resources.Missing, FilePath)
end

function Resources.Init()
    LoveEvents.Focus:Connect(function()
        --Resources.ReloadResources()
    end)
end

-- sorta hack for studio assets
function Resources.GetStudioPath(IdentifierID)
    local PathSplit = string.split(IdentifierID, "/")

    if PathSplit[1] == "Internal" then
        local PathString = table.concat(PathSplit, "/", 2)
        local InternalPath = Path.new(PathString, IdentifierID)
        InternalPath.Internal = true
    
        return InternalPath
    end
end

-- Get the identifier, which holds the file path itself, 
function Resources.GetIdentifier(IdentifierID) 
    local ReturnIdentifier = Resources.GetStudioPath(IdentifierID) or Identifiers[IdentifierID]
    assert(ReturnIdentifier, IdentifierID.." Doesnt exist!")

    return ReturnIdentifier
end

function Resources.ClearIdentifier() 
    Identifiers = {} 
    LoadedResources = {}
    ObjectReferences = {}
end

function Resources.ReloadResources()
    print("Reloading resources")

    -- It'd be nice if we could know WHICH were changed without checking them all but whatever
    for Object, Identifier in pairs(ObjectReferences) do
        LoadedResources[Identifier.Identifier] = nil

        Object:SetResource(Identifier)
    end

    print(LoadedResources)
    print("Done")
end

Resources.ClearIdentifier()

-- Takes an Identifier object or ID and returns the Resource, alongside its Identifier
function Resources.LoadFromIdentifier(Identifier, Object)
    if Utils.TypeOf(Identifier) == "string" then
        printVerbose("Calling LoadFromIdentifier with IdentifierID instead of Identifier, Try to use Identifier when possible, but IdentifierID is fine.")
        Identifier = Runtime.Resources.GetIdentifier(Identifier)
    end

    if not Identifier.Internal then
        print("Adding "..Object.." to object references")
        ObjectReferences[Object] = Identifier
    end

    return Resources.GetResource(Identifier), Identifier
end

function Resources.LoadResource(FilePath)
    local Format = FormatLookup[FilePath.FileType]

    local LoaderModule = require(LoaderModPath..Format)
    local Contents

    if FilePath.Internal then
        Contents = love.filesystem.read("Assets/"..FilePath.FilePath)
    else
        Contents = Runtime.BackendFS.ReadFile(FilePath.FilePath)
    end

    local Resource = LoaderModule(Contents, FilePath)

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