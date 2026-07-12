-- Welcome to resource hell
local Resources = {}

local Identifiers = require("Runtime.Resources.Identifiers")
local FormatLookup = require("Runtime.Resources.FormatLookup")

local LoaderModPath = "Runtime.Resources.Loaders."
local LoadedResources
local ObjectReferences = {}

Resources.Missing = {}

function Resources.Init()
    LoveEvents.Focus:Connect(function()
        --Resources.ReloadResources()
    end)

    Resources.GetIdentifierFromID = Identifiers.GetIdentifierFromID
    Resources.LoadOrCreateIdentifier = Identifiers.LoadOrCreateIdentifier
    Resources.RegisterAsMissing = Identifiers.RegisterAsMissing
    Resources.LoadIdentifierIDFromPath = Identifiers.LoadIdentifierIDFromPath
end

-- Save resources to a new path (TODO)
function Resources.SaveResources()
    
end

function Resources.Clear() 
    Identifiers.Clear()
    LoadedResources = {}
    ObjectReferences = {}
end

Resources.Clear()

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

-- Get a resource from an IdentifierID or Identifier
function Resources.LoadResourceFromIdentifier(Identifier, Object)
    assert(Identifier, "No identifier passed into LoadResourceFromIdentifier")

    local Type = Utils.TypeOf(Identifier)

    if Type == "string" then
        printVerbose("Calling LoadResourceFromIdentifier with IdentifierID instead of Identifier, Try to use Identifier when possible, but IdentifierID is fine.")
        Identifier = Identifiers.GetIdentifierFromID(Identifier)
    elseif Type == "userdata" then
        Identifier = IdentifierType.new(Identifier, "Buffer", "Buffer-"..CreateUUID())
    end

    if Identifier.ResourceType == "Project" then
        printVerbose("Adding "..Object.." to object references")
        ObjectReferences[Object] = Identifier
    end

    return Resources.GetResource(Identifier), Identifier
end

local function LoadWithContents(Identifier, Contents)
    local Format = FormatLookup[Identifier.Data.FileType]
    local LoaderModule = require(LoaderModPath..Format)

    assert(Contents, "Cannot read resource (Identifier: "..Identifier.ID..", Path: "..Identifier.Data.FilePath..")")
    Resource = LoaderModule(Contents, Identifier)

    return Resource
end

-- Get a resource from an Identifier
function Resources.GetResource(Identifier)
    if (not Identifier) then return end

    if not LoadedResources[Identifier.ID] then -- If the resource isnt loaded yet, cache it
        local ResourceType = Identifier.ResourceType
        local Resource

        if ResourceType == "Internal" then
            Resource = LoadWithContents(Identifier, love.filesystem.read("Assets/"..Identifier.Data.FilePath))
        elseif ResourceType == "Project" then
            Resource = LoadWithContents(Identifier, Runtime.ProjectFS.ReadFile(Identifier.Data.FilePath))
        elseif ResourceType == "Buffer" then
            Resource = Identifier.Data
        end

        if not (Identifier.ID and Resource) then
            print(Identifier)
            error("Invalid Identifier for GetResource")
        end

        LoadedResources[Identifier.ID] = Resource
    end

    return LoadedResources[Identifier.ID]
end

function Resources.UnloadResource(Identifier)
    print("TODO")
end

return Resources