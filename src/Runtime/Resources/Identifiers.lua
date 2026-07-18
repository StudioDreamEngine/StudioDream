local Identifiers = {}
local RegisteredIdentifiers = {}

Identifiers.Missing = {}

-- Given a file path (relative to system root), load any file, inside or outside the project.
function Identifiers.LoadIdentifierIDFromPath(FilePath)
	local Mount = Runtime.ProjectFS.GetMount()

	print(Mount, ", ", FilePath)

	if not Mount then
		Utils.Warn("A project needs to be loaded first before you can load resources")
		return
	end

	if not string.find(FilePath, Mount) then
		local FileName = string.split(FilePath, "/")
		FileName = FileName[#FileName]

		local Data = Runtime.BaseFS.ReadFile(FilePath)
		return Identifiers.LoadOrCreateIdentifier(FileName, Data)
	else
		local RelativePath = string.gsub(FilePath, Mount, "") -- This couldnt go wrong at all
		print(RelativePath)

		return Identifiers.LoadOrCreateIdentifier(RelativePath)
	end
end

--[[
	Get the IdentifierID of the specified Path (FilePath)
	This will NOT register an identifier OR create a new file.
]]
function Identifiers.GetIdentifierIDFromPath(FilePath)
	local ProjectFS = Runtime.ProjectFS

	if Utils.TypeOf(FilePath) == "Path" then
		FilePath = FilePath.FilePath
	end

	return ProjectFS.ReadFile(FilePath .. ".uid")
end

-- Given a file path (relative to the project mount), create the file (if it doesnt exist) and register an identifier
function Identifiers.LoadOrCreateIdentifier(FilePath, FileData)
	local ProjectFS = Runtime.ProjectFS

	if not ProjectFS.GetMount() then
		Utils.Warn("A project needs to be loaded first before a resource can be created")
		return
	end
	
	assert(FilePath, "FilePath not passed")
	assert(type(FilePath) == "string", "FilePath can only be a string value.\nIf you want to find an IdentifierID from a path, use Resources.GetIdentifierIDFromPath")

	local HasIdentifier = ProjectFS.FileExists(FilePath .. ".uid")
	local HasFile = ProjectFS.FileExists(FilePath)

	-- This file is a directory, pass that along to the function that called this, as it may be used to handle loading/reloading all resources
	if HasFile and HasFile.type == "directory" then
		printVerbose("File was directory")
		return nil, true
	end

	if not HasFile then
		print("Writing new file @ path:",FilePath)

		Runtime.ProjectFS.WriteFile(FilePath, FileData or "")
	end

	local Identifier

	if not HasIdentifier then -- Create a new identifier
		Identifier = CreateUUID()
		ProjectFS.WriteFile(FilePath .. ".uid", Identifier)
	else
		Identifier = ProjectFS.ReadFile(FilePath .. ".uid")
	end

	Identifiers.RegisterIdentifier(Identifier, FilePath)

	return Identifier, false
end

-- Configure (Register) an Identifier to be Associated with a File Path
function Identifiers.RegisterIdentifier(Identifier, FilePath)
	local NewIdentifier = IdentifierType.new(Path.new(FilePath), "Project", Identifier)
	RegisteredIdentifiers[Identifier] = NewIdentifier

	return NewIdentifier
end

-- Register an IdentifierID as missing its identifier counterpart, used during project load
function Identifiers.RegisterAsMissing(Identifier)
	Shared.QueueAbort("ResourceID " .. Identifier .. " is missing, You can resolve missing resources in the Project tab.")
	table.insert(Identifiers.Missing, Identifier)
end

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
function Identifiers.GetIdentifierFromID(IdentifierID)
	if type(IdentifierID) ~= "string" then -- Buffer type, hate the fact this is done twice
		return IdentifierType.new(IdentifierID, "Buffer", "Buffer-" .. CreateUUID())
	else -- Internal and Project type
		return Identifiers.GetStudioPath(IdentifierID) or RegisteredIdentifiers[IdentifierID]
	end
end

function Identifiers.Clear()
	RegisteredIdentifiers = {}
end

return Identifiers
