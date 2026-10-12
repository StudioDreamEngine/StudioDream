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
	Resources.Unload = Identifiers.Unload
	Resources.GetOrCreateIdentifierID = Identifiers.GetOrCreateIdentifierID
	Resources.LoadOrCreateIdentifier = Identifiers.LoadOrCreateIdentifier
	Resources.RegisterAsMissing = Identifiers.RegisterAsMissing
	Resources.LoadIdentifierIDFromPath = Identifiers.LoadIdentifierIDFromPath
	Resources.GetIdentifierIDFromPath = Identifiers.GetIdentifierIDFromPath
	Resources.CreateIdentifier = Identifiers.CreateIdentifier
	Resources.CreateBuffer = Identifiers.CreateBuffer
	Resources.ChangeBuffer = Identifiers.ChangeBuffer
	Resources.UnregisterIdentifier = Identifiers.UnregisterIdentifier
end

function Resources.Clear()
	Identifiers.Clear()
	LoadedResources = {}
	ObjectReferences = {}
end

Resources.Clear()

function Resources.ForEachReference(Callback)
	for ObjectUUID, Properties in pairs(ObjectReferences) do
		for Property, Identifier in pairs(Properties) do
			Callback(Identifier, ObjectUUID, Property)
		end
	end
end

function Resources.ReloadResources()
	print("Reloading resources")

	-- It'd be nice if we could know WHICH were changed without checking them all but whatever
	-- TODO: Also reload
	Resources.ForEachReference(function(Identifier, ObjectUUID, Property)
		local Object = Runtime.Things.Get(ObjectUUID)
		--print(Identifier, Property)

		Resources.LoadResource(Identifier)
		Object["Set"..Property](Object, Identifier)
	end)

	print("Done")
end

--[[
	Get or Load a resource from an IdentifierID or Identifier
	Intended to be a way to simplify loading resources from Identifiers or IDs

	
]]
function Resources.LoadResourceFromIdentifier(Identifier, Object, ResourceInfo)
	assert(Identifier, "No identifier passed into LoadResourceFromIdentifier")

	-- TODO: Should we deprecate using identifiers for LoadResourceFromIdentifier?

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
		if (not ObjectReferences[ObjectUUID]) then
			ObjectReferences[ObjectUUID] = {}
		end

		printVerbose("Adding " .. ObjectUUID .. " to object references")
		ObjectReferences[ObjectUUID][CustomProperty] = Identifier
	end
	
	local ResourceReturn, ResourceSource = Resources.GetResource(Identifier)
	return ResourceReturn, Identifier.ID, ResourceSource
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
	return Loader, Loader2
end

-- Use a Resource Loader given the specified data and format
function Resources.InitiateLoader(Format, Contents, Identifier)
	local LoaderFunction = require(LoaderModPath .. Format).Load

	local Resource, SourceResource = LoaderFunction(Contents, Identifier)
	return Resource, SourceResource
end

function Resources.LoadResource(Identifier)
	local ResourceType = Identifier.ResourceType
	local Resource

	Resources.UnloadResource(Identifier.ID)

	if ResourceType == "Internal" then
		Resource, SourceResource = LoadWithContents(Identifier, love.filesystem.read("Assets/" .. Identifier.Data.FilePath))
	elseif ResourceType == "Project" then
		Resource, SourceResource = LoadWithContents(Identifier, Runtime.ProjectFS.ReadFile(Identifier.Data.FilePath))
	elseif ResourceType == "Buffer" then
		Resource = Identifier.Data
	else
		error("Invalid ResourceType "..(ResourceType or "Unknown"))
	end

	LoadedResources[Identifier.ID] = {
		Resource = Resource,
		Source = SourceResource
	}

	return Resource, SourceResource
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
	local Resource

	if (not LoadedResource) or Reload then -- If the resource isnt loaded yet, cache it
		Resource, SourceResource = Resources.LoadResource(Identifier)
	else
		Resource, SourceResource = LoadedResource.Resource, LoadedResource.Source
	end

	return Resource, SourceResource
end

function Resources.UnloadResource(IdentifierID)
	local Resource = LoadedResources[IdentifierID]

	if Resource then
		local Identifier = Identifiers.GetIdentifierFromID(IdentifierID)

		if Identifier.ResourceType == "Project" then
			local Format = FormatLookup[Identifier.Data.FileType]

			if (not Format) then
				error("Invalid resource format, this error SHOULD NOT OCCUR if you used LoadResourceFromIdentifier to load this.")
				return
			end

			Resources.ForEachReference(function(_, ObjectUUID, Property)
				local Object = Runtime.Things.Get(ObjectUUID)
				Runtime.Things.SetProperty(Object, Property, nil)
			end)

			local UnloaderFunction = require(LoaderModPath .. Format).Unload
			UnloaderFunction(Resource.Resource)
		end
	end

	LoadedResources[IdentifierID] = nil
end

return Resources
