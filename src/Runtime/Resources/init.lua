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
    if (not Identifier) then
        print("No identifier passed into LoadResourceFromIdentifier")
        print(debug.traceback())
        return
    end

    if Utils.TypeOf(Identifier) == "string" then
        printVerbose("Calling LoadResourceFromIdentifier with IdentifierID instead of Identifier, Try to use Identifier when possible, but IdentifierID is fine.")
        Identifier = Identifiers.GetIdentifierFromID(Identifier)
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
            Contents = Runtime.ProjectFS.ReadFile(Identifier.FilePath)
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