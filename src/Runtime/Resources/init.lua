-- Welcome to resource hell
local Resources = {}

local Identifiers = require("Runtime.Resources.Identifiers")
local FormatLookup = require("Runtime.Resources.FormatLookup")

local LoaderModPath = "Runtime.Resources.Loaders."
local LoadedResources
local ObjectReferences = {}

local Clonable = { "Sound" }

Resources.Missing = {}

function Resources.Init()
	LoveEvents.Focus:Connect(function()
		--Resources.ReloadResources()
	end)

	Resources.GetIdentifierFromID = Identifiers.GetIdentifierFromID
	Resources.GetOrCreateIdentifierID = Identifiers.GetOrCreateIdentifierID
	Resources.LoadOrCreateIdentifier = Identifiers.LoadOrCreateIdentifier
	Resources.RegisterAsMissing = Identifiers.RegisterAsMissing
	Resources.LoadIdentifierIDFromPath = Identifiers.LoadIdentifierIDFromPath
	Resources.GetIdentifierIDFromPath = Identifiers.GetIdentifierIDFromPath
	Resources.CreateIdentifier = Identifiers.CreateIdentifier
	Resources.CreateBuffer = Identifiers.CreateBuffer
	Resources.ChangeBuffer = Identifiers.ChangeBuffer
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
	for ObjectProp, Identifier in pairs(ObjectReferences) do
		local Split = string.split(ObjectProp, "_")
		local ObjectUUID, Property = Split[1], Split[2]
		local Object = Runtime.Things.Get(ObjectUUID)
		--print(Identifier, Property)

		Resources.LoadResource(Identifier)
		Object["Set"..Property](Object, Identifier)
	end

	print("Done")
end

--[[
	Get or Load a resource from an IdentifierID or Identifier
	Intended to be a way to simplify loading resources from Identifiers or IDs

	
]]
function Resources.LoadResourceFromIdentifier(Identifier, Object, ResourceInfo)
	assert(Identifier, "No identifier passed into LoadResourceFromIdentifier")

	local IntendedType, CustomProperty = nil, "Resource"

	if type(ResourceInfo) == "string" then -- Backwards compat for now
		IntendedType = ResourceInfo
	elseif ResourceInfo then
		IntendedType = ResourceInfo.Type
		CustomProperty = ResourceInfo.Property
	end

	--[[printVerbose(
		"Calling LoadResourceFromIdentifier with IdentifierID instead of Identifier, Try to use Identifier when possible, but IdentifierID is fine."
	)]]
	Identifier = Identifiers.GetIdentifierFromID(Identifier)

	local ObjectUUID = (type(Object) == "table" and Object.UUID or Object)

	if ObjectUUID and (Identifier.ResourceType ~= "Buffer") then
		--print(Identifier)
		local Path = Identifier.Data ---@class Path
		local CurrentType = FormatLookup[Path.FileType]

		if CurrentType ~= IntendedType then
			print("Identifier file type was not the expected type, Expected "..IntendedType..", got "..CurrentType)
			return
		end
	end

	if Identifier.ResourceType == "Project" and ObjectUUID then
		printVerbose("Adding " .. ObjectUUID .. " to object references")
		ObjectReferences[ObjectUUID.."_"..CustomProperty] = Identifier
	elseif Identifier.ResourceType ~= "Internal" then
		printVerbose("Cannot add", Identifier, "to ObjectReferences")
	end
	
	local ResourceReturn, ResourceReturnSecond = Resources.GetResource(Identifier)
	return ResourceReturn, Identifier.ID, ResourceReturnSecond
end

local function LoadWithContents(Identifier, Contents)
	local Format = FormatLookup[Identifier.Data.FileType]

	if (not Format) then
		error("Invalid resource format, this error SHOULD NOT OCCUR if you used LoadResourceFromIdentifier to load this.")
		return
	end

	assert(
		Contents,
		"Cannot read resource (Identifier: " .. Identifier.ID .. ", Path: " .. Identifier.Data.FilePath .. ")"
	)
	local Loader, Loader2 = Resources.InitiateLoader(Format, Contents, Identifier)
	return Loader, table.find(Clonable, Format), Loader2
end

-- Use a Resource Loader given the specified data and format
function Resources.InitiateLoader(Format, Contents, Identifier)
	local LoaderModule = require(LoaderModPath .. Format)

	local Resource, SecondResource = LoaderModule(Contents, Identifier)
	return Resource, SecondResource
end

function Resources.LoadResource(Identifier)
	local ResourceType = Identifier.ResourceType
	local Resource, Clonable

	if ResourceType == "Internal" then
		Resource, Clonable, SecondResource = LoadWithContents(Identifier, love.filesystem.read("Assets/" .. Identifier.Data.FilePath))
	elseif ResourceType == "Project" then
		Resource, Clonable, SecondResource = LoadWithContents(Identifier, Runtime.ProjectFS.ReadFile(Identifier.Data.FilePath))
	elseif ResourceType == "Buffer" then
		Resource = Identifier.Data
	else
		error("Invalid ResourceType "..(ResourceType or "Unknown"))
	end

	LoadedResources[Identifier.ID] = Resource

	--[[if (not LoadedResources[Identifier.ID]) then
		LoadedResources[Identifier.ID] = {
			Clonable = Clonable
		}
	end

	if Clonable then
		table.insert(LoadedResources[Identifier.ID], Resource)
	else
		LoadedResources[Identifier.ID][1] = Resource
	end]]

	return Resource, SecondResource
end

function Resources.WriteResource(IdentifierID, Data)
	local Identifier = Identifiers.GetIdentifierFromID(IdentifierID)

	if Identifier.ResourceType == "Project" then
		local IdentifierData = Identifier.Data ---@class Path

		Runtime.ProjectFS.QueueWrite(IdentifierData.FilePath..".uid", Identifier.ID)
		Runtime.ProjectFS.QueueWrite(IdentifierData.FilePath, Data or Runtime.ProjectFS.ReadFile(IdentifierData.FilePath)) -- Code reuse... too bad!
	end
end

-- Save resources to a new path
function Resources.SaveResources()
	---@param Identifier Identifier
	for ID, Identifier in pairs(Identifiers.GetAll()) do
		Resources.WriteResource(ID)
	end
end

--[[
	Get a resource from an Identifier

	Identifier: The identifier object used to grab said resource
	Reload?: If this resource should be re-cached or not
]]
function Resources.GetResource(Identifier, Reload)
	if not Identifier then return end

	local LoadedResource = LoadedResources[Identifier.ID]
	local SecondLoadedResource

	if (not LoadedResource) or Reload then -- If the resource isnt loaded yet, cache it
		LoadedResource, SecondLoadedResource = Resources.LoadResource(Identifier)
	end

	return LoadedResource, SecondLoadedResource
end

function Resources.UnloadResource(IdentifierID)
	LoadedResources[IdentifierID] = nil
end

return Resources
