local Identifiers = {}
local RegisteredIdentifiers = {}
local DuplicateCounts = {}

Identifiers.Missing = {}

---@param FilePath string
-- Given a file path (relative to system root), load any file, inside or outside the project.
function Identifiers.LoadIdentifierIDFromPath(FilePath)
	local Mount = Runtime.ProjectFS.GetMount()

	print(Mount, ", ", FilePath)

	if not Mount then
		Utils.Warn("A project needs to be loaded first before you can load resources")
		return
	end

	if not string.find(FilePath, Mount) then
		printVerbose("Loading from external")
	
		local FileName = string.split(FilePath, "/")
		FileName = FileName[#FileName]

		local Data = Runtime.BaseFS.ReadFile(FilePath)
		return Identifiers.LoadOrCreateIdentifier(FileName, Data)
	else
		printVerbose("Loading from local")

		local RelativePath = string.gsub(FilePath, Mount, "") -- This couldnt go wrong at all
		print(RelativePath)

		return Identifiers.LoadOrCreateIdentifier(RelativePath)
	end
end

--[[function Identifiers.GetPathFromIdentifierID(Identifier)
	--Todo
end]]

---@param FilePath string
--[[
	Get the IdentifierID of the specified Path (FilePath)
	This will NOT register an identifier OR create a new file.
	FilePath is relative to the project mount point.

	TODO: Is this needed?
]]
function Identifiers.GetIdentifierIDFromPath(FilePath)
	if Utils.TypeOf(FilePath) == "Path" then
		FilePath = FilePath.FilePath
	end

	return Runtime.ProjectFS.ReadFile(FilePath .. ".uid")
end

---@param Identifier string
---@param FilePath string
-- Configure (Register) an Identifier to be Associated with a File Path
local function RegisterIdentifier(Identifier, FilePath)
	local PathObj = Path.new(FilePath) ---@class Path

	local NewIdentifier = IdentifierType.new(PathObj, "Project", Identifier)
	RegisteredIdentifiers[Identifier] = NewIdentifier

	return NewIdentifier
end

---@param FilePath string
---@param CheckDuplicates boolean?
--[[
	Given a file path, create SOLELY the identifier id
]]
function Identifiers.GetOrCreateIdentifierID(FilePath, CheckDuplicates)
	local ProjectFS = Runtime.ProjectFS
	local FinalPath
	
	if CheckDuplicates then
		FilePath = Path.new(FilePath) ---@diagnostic disable-line: cast-local-type

		local ParentPath = FilePath.GetParent().FilePath
		local FileName = FilePath.FileName

		local DirectoryItems = Runtime.ProjectFS.ListDirectory(ParentPath)
		local TotalDuplicates = 0

		while true do
			FileName = FilePath.FileName..((TotalDuplicates > 0) and TotalDuplicates or "").."."..FilePath.FileType
			TotalDuplicates = TotalDuplicates + 1

			if (not table.find(DirectoryItems, FileName)) then
				break
			end
		end

		FinalPath = ParentPath..FileName
	else
		FinalPath = FilePath
	end

	-- use the old identifier if it exists
	local HasIdentifier = ProjectFS.FileExists(FinalPath .. ".uid")
	local IdentifierID

	if not HasIdentifier then -- Create a new identifier
		IdentifierID = CreateUUID()
		ProjectFS.QueueWrite(FinalPath .. ".uid", IdentifierID)
	else
		IdentifierID = ProjectFS.ReadFile(FinalPath .. ".uid")
	end

	RegisterIdentifier(IdentifierID, FinalPath)

	return IdentifierID
end

---@param FilePath string
---@param FileData? string
--[[
	Given a file path (relative to the project mount), create the file (if it doesnt exist) and register an identifier 
	TODO: Replace this with a function that calls GetOrCreateIdentifierID followed by Resources.WriteResource
	
	(THIS DOES NOT HANDLE DUPLICATES IN THE CASE OF CREATION, USE Resources.CreateIdentifier for that)
]]
function Identifiers.LoadOrCreateIdentifier(FilePath, FileData)
	local ProjectFS = Runtime.ProjectFS

	if not ProjectFS.GetMount() then
		Utils.Warn("A project needs to be loaded first before a resource can be created")
		return
	end
	
	assert(FilePath, "FilePath not passed")
	assert(type(FilePath) == "string", "FilePath can only be a string value.\nIf you want to find an IdentifierID from a path, use Resources.GetIdentifierIDFromPath")

	local HasFile = ProjectFS.FileExists(FilePath)

	-- This file is a directory, pass that along to the function that called this, as it may be used to handle loading/reloading all resources
	if HasFile and HasFile.type == "directory" then
		printVerbose("File was directory")
		return nil, true
	end

	if (not HasFile) or FileData then
		print("Writing new file @ path:",FilePath)

		ProjectFS.QueueWrite(FilePath, FileData or "")
	end

	local IdentifierID = Identifiers.GetOrCreateIdentifierID(FilePath)
	return IdentifierID, false
end

function Identifiers.CreateBuffer(Data)
	local ID = "Buffer-"..CreateUUID()
	local Identifier = IdentifierType.new(Data, "Buffer", ID)

	RegisteredIdentifiers[Identifier.ID] = Identifier

	return Identifier
end

function Identifiers.ChangeBuffer(IdentiferID, NewBuffer)
	assert(RegisteredIdentifiers[IdentiferID], "You need to create the buffer before you can change its contents")

	RegisteredIdentifiers[IdentiferID].Data = NewBuffer
	Runtime.Resources.UnloadResource(IdentiferID) -- We need to re-load the identifier on next use
end

---@param Identifier string
-- Register an IdentifierID as missing its identifier counterpart, used during project load
function Identifiers.RegisterAsMissing(Identifier, Invalid)
	local String = Invalid and "no longer supported" or "missing"

	Shared.QueueAbort("ResourceID " .. Identifier .. " is "..String..", You can resolve missing resources in the Project tab.")
	table.insert(Identifiers.Missing, Identifier)
end

---@param IdentifierID string
-- Get an internal path for a studio asset, only used for studio.
function Identifiers.GetStudioPath(IdentifierID)
	local PathSplit = string.split(IdentifierID, "/")

	if PathSplit[1] == "Internal" then
		local PathString = table.concat(PathSplit, "/", 2)
		local Path = Path.new(PathString)

		return IdentifierType.new(Path, "Internal", IdentifierID)
	end
end

-- Get an identifier from an IdentifierID
---@return Identifier
function Identifiers.GetIdentifierFromID(IdentifierID)
	if type(IdentifierID) == "table" then
		return IdentifierID
	end
	
	return Identifiers.GetStudioPath(IdentifierID) or RegisteredIdentifiers[IdentifierID]
end

function Identifiers.GetAll()
	return RegisteredIdentifiers
end

function Identifiers.Clear()
	RegisteredIdentifiers = {}
end

return Identifiers
