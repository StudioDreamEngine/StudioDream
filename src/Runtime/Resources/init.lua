-- Welcome to resource hell
local Resources = {}

local LoaderModPath = "Runtime.Resources.Loaders."
local Identifiers, LoadedResources
local ObjectReferences = {}

Resources.Missing = {}

local FormatLookup = require("Runtime.Resources.FormatLookup")

function Resources.Init()
    LoveEvents.Focus:Connect(function()
        --Resources.ReloadResources()
    end)
end

-- Given a file path (relative to system root), load any file, inside or outside the project.
function Resources.LoadIdentifierIDFromPath(FilePath)
    local Mount = Runtime.BackendFS.GetMount()

    print(Mount, ", ", FilePath)

    if (not string.find(FilePath, Mount)) then
        print("Identifier outside of mount point currently not supported")
    else
        local RelativePath = string.gsub(FilePath, Mount, "") -- This couldnt go wrong at all
        print(RelativePath)

        return Resources.LoadOrCreateIdentifier(RelativePath)
    end
end

-- Given a file path (relative to the project mount), register an identifier, or create the file and register the identifier for it
function Resources.LoadOrCreateIdentifier(FilePath, FileData)
    local BackendFS = Runtime.BackendFS

    local HasIdentifier = BackendFS.FileExists(FilePath..".uid")
    local HasFile = BackendFS.FileExists(FilePath)

    -- This file is a directory, pass that along to the function that called this, as it may be used to handle loading/reloading all resources
    if HasFile and HasFile.type == "directory" then return nil, true end

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

    return Identifier, false
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
function Resources.GetIdentifierFromID(IdentifierID) 
    return Resources.GetStudioPath(IdentifierID) or Identifiers[IdentifierID]
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
function Resources.LoadResourceFromIdentifier(Identifier, Object)
    if (not Identifier) then
        print("No identifier passed into LoadResourceFromIdentifier")
        print(debug.traceback())
        return
    end

    if Utils.TypeOf(Identifier) == "string" then
        printVerbose("Calling LoadResourceFromIdentifier with IdentifierID instead of Identifier, Try to use Identifier when possible, but IdentifierID is fine.")
        Identifier = Runtime.Resources.GetIdentifierFromID(Identifier)
    end

    -- TODO: Maybe move this to GetResource?
    if not Identifier.Internal then
        printVerbose("Adding "..Object.." to object references")
        ObjectReferences[Object] = Identifier
    end

    return Resources.GetResource(Identifier), Identifier
end

-- Get a resource from an Identifier
function Resources.GetResource(Identifier)
    if (not Identifier) then return end

    if not LoadedResources[Identifier.Identifier] then -- If the resource isnt loaded yet, cache it
        local Format = FormatLookup[Identifier.FileType]

        local LoaderModule = require(LoaderModPath..Format)
        local Contents

        if Identifier.Internal then
            Contents = love.filesystem.read("Assets/"..Identifier.FilePath)
        else
            Contents = Runtime.BackendFS.ReadFile(Identifier.FilePath)
        end

        assert(Contents, "Cannot read resource (Identifier: "..Identifier.Identifier..", Path: "..Identifier.FilePath..")")
        local Resource = LoaderModule(Contents, Identifier)

        LoadedResources[Identifier.Identifier] = Resource
    end

    return LoadedResources[Identifier.Identifier]
end

function Resources.UnloadResource(Identifier)
    print("TODO")
end

return Resources