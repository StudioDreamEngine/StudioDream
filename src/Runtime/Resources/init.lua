-- Welcome to resource hell
local Resources = {}

local LoaderModPath = "Runtime.Resources.Loaders."
local Identifiers, LoadedResources
local ObjectReferences = {}

local FormatLookup = require("Runtime.Resources.FormatLookup")

function Resources.Init()
    LoveEvents.Focus:Connect(function()
        --Resources.ReloadResources()
    end)
end

-- Given a file path (relative to root directory), load any file, inside or outside the project.
function Resources.LoadIdentifier(FilePath)
    local Mount = Runtime.BackendFS.GetMount()

    if (not string.find(FilePath, Mount)) then
        print("Identifier outside of mount point")
    else
        print("Identifier within mount point")
    end
end

-- Given a file path (relative to the project mount), register an identifier, or create the file and register the identifier for it
function Resources.LoadOrCreateIdentifier(FilePath, FileData)
    local BackendFS = Runtime.BackendFS

    local HasIdentifier = BackendFS.FileExists(FilePath..".uid")
    local HasFile = BackendFS.FileExists(FilePath)

    if (not HasFile) then
        Runtime.BackendFS.WriteFile(FilePath, FileData)
    end
    
    local Identifier

    if (not HasIdentifier) then -- Create a new identifier
        Identifier = CreateUUID()
        BackendFS.WriteFile(FilePath..".uid", Identifier)
    else
        Identifier = BackendFS.ReadFile(FilePath..".uid")
    end

    Resources.RegisterIdentifier(Identifier, FilePath)

    return Identifier, HasIdentifier
end

-- Configure (Register) an Identifier to be Associated with a File Path
function Resources.RegisterIdentifier(Identifier, FilePath) Identifiers[Identifier] = Path.new(FilePath, Identifier) end

-- Register an IdentifierID as missing its identifier counterpart, used during project load
function Resources.RegisterAsMissing(FilePath)
    print(FilePath.Identifier.." is missing! old path: "..FilePath.FilePath)
    table.insert(Resources.Missing, FilePath)
end

-- Get an internal path for a studio asset, only used for studio.
function Resources.GetStudioPath(IdentifierID)
    local PathSplit = string.split(IdentifierID, "/")

    if PathSplit[1] == "Internal" then
        local PathString = table.concat(PathSplit, "/", 2)
        local InternalPath = Path.new(PathString, IdentifierID)
        InternalPath.Internal = true
    
        return InternalPath
    end
end

-- Get an identifier from an IdentifierID
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
    -- TODO: Also reload 
    for Object, Identifier in pairs(ObjectReferences) do
        LoadedResources[Identifier.Identifier] = nil

        Object:SetResource(Identifier)
    end

    print(LoadedResources)
    print("Done")
end

Resources.ClearIdentifier()

-- Get a resource from an IdentifierID or Identifier
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

-- Internal function to Load a resource itself, called once per resource
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

-- Get a resource from an Identifier
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