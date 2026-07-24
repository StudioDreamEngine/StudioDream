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
	Resources.GetIdentifierIDFromPath = Identifiers.GetIdentifierIDFromPath
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

--[[
	Get or Load a resource from an IdentifierID or Identifier
	Intended to be a way to simplify loading resources from Identifiers or IDs
]]
function Resources.LoadResourceFromIdentifier(Identifier, Object, Reload)
	assert(Identifier, "No identifier passed into LoadResourceFromIdentifier")

	local Type = Utils.TypeOf(Identifier)

	if Type == "string" then
		printVerbose(
			"Calling LoadResourceFromIdentifier with IdentifierID instead of Identifier, Try to use Identifier when possible, but IdentifierID is fine."
		)
		Identifier = Identifiers.GetIdentifierFromID(Identifier)
	elseif Type == "userdata" then -- TODO: Merge w/ Above
		Identifier = IdentifierType.new(Identifier, "Buffer", "Buffer-" .. CreateUUID())
	end

	if Identifier.ResourceType == "Project" and Object then
		printVerbose("Adding " .. Object .. " to object references")
		ObjectReferences[Object] = Identifier
	end

	return Resources.GetResource(Identifier, Reload), Identifier
end

local function LoadWithContents(Identifier, Contents)
	local Format = FormatLookup[Identifier.Data.FileType]

	if (not Format) then
		print("Invalid resource format")
		return "Invalid"
	end

	assert(
		Contents,
		"Cannot read resource (Identifier: " .. Identifier.ID .. ", Path: " .. Identifier.Data.FilePath .. ")"
	)

	return Resources.InitiateLoader(Format, Contents, Identifier)
end

-- Use a Resource Loader given the specified data and format
function Resources.InitiateLoader(Format, Contents, Identifier)
	local LoaderModule = require(LoaderModPath .. Format)

	local Resource = LoaderModule(Contents, Identifier)
	return Resource
end

function Resources.LoadResource(Identifier)
	local ResourceType = Identifier.ResourceType
	local Resource

	if ResourceType == "Internal" then
		Resource = LoadWithContents(Identifier, love.filesystem.read("Assets/" .. Identifier.Data.FilePath))
	elseif ResourceType == "Project" then
		Resource = LoadWithContents(Identifier, Runtime.ProjectFS.ReadFile(Identifier.Data.FilePath))
	elseif ResourceType == "Buffer" then
		Resource = Identifier.Data
	else
		error("Invalid ResourceType "..ResourceType)
	end

	LoadedResources[Identifier.ID] = Resource

	return Resource
end

function Resources.SaveResource(IdentifierID)
	local Identifier = Identifiers.GetIdentifierFromID(IdentifierID)

	if Identifier.ResourceType == "Project" then
		local IdentifierData = Identifier.Data ---@class Path

		Runtime.ProjectFS.QueueWrite(IdentifierData.FilePath, Runtime.ProjectFS.ReadFile(Identifier.Data.FilePath)) -- Code reuse... oh well!
	end
end

-- Save resources to a new path
function Resources.SaveResources()
	---@param Identifier Identifier
	for ID, Identifier in pairs(Identifiers.GetAll()) do
		Resources.SaveResource(ID)
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
	if (LoadedResource == "Invalid") then return end

	if Reload or (not LoadedResource) then -- If the resource isnt loaded yet, cache it
		LoadedResource = Resources.LoadResource(Identifier)
	end

	return LoadedResource
end

function Resources.UnloadResource(Identifier)
	print("TODO")
end

return Resources
