local Identifiers = {}
local RegisteredIdentifiers = {}

Identifiers.Missing = {}

-- Given a file path (relative to system root), load any file, inside or outside the project.
function Identifiers.LoadIdentifierIDFromPath(FilePath)
    local Mount = Runtime.BackendFS.GetMount()

    print(Mount, ", ", FilePath)

    if (not Mount) then
        Utils.Warn("A project needs to be loaded first before you can load resources")
        return
    end

    if (not string.find(FilePath, Mount)) then
        Utils.Warn("Identifier outside of mount point currently not supported")
    else
        local RelativePath = string.gsub(FilePath, Mount, "") -- This couldnt go wrong at all
        print(RelativePath)

        return Identifiers.LoadOrCreateIdentifier(RelativePath)
    end
end

-- Given a file path (relative to the project mount), register an identifier, or create the file and register the identifier for it
function Identifiers.LoadOrCreateIdentifier(FilePath, FileData)
    local BackendFS = Runtime.BackendFS

    if (not BackendFS.GetMount()) then
        Utils.Warn("A project needs to be loaded first before a resource can be created")
        return
    end

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

    Identifiers.RegisterIdentifier(Identifier, FilePath)

    return Identifier, false
end

-- Configure (Register) an Identifier to be Associated with a File Path
function Identifiers.RegisterIdentifier(Identifier, FilePath)
    local NewIdentifier = Path.new(FilePath, Identifier)
    RegisteredIdentifiers[Identifier] = NewIdentifier

    return NewIdentifier
end

-- Register an IdentifierID as missing its identifier counterpart, used during project load
function Identifiers.RegisterAsMissing(FilePath)
    Shared.QueueAbort(FilePath.Identifier.." is missing! old path: "..FilePath.FilePath)
    table.insert(Identifiers.Missing, FilePath)
end

-- Get an internal path for a studio asset, only used for studio.
function Identifiers.GetStudioPath(IdentifierID)
    local PathSplit = string.split(IdentifierID, "/")

    if PathSplit[1] == "Internal" then
        local PathString = table.concat(PathSplit, "/", 2)
        local InternalPath = Path.new(PathString, IdentifierID)
        InternalPath.Internal = true
    
        return InternalPath
    end
end

-- Get an identifier from an IdentifierID
function Identifiers.GetIdentifierFromID(IdentifierID) 
    return Identifiers.GetStudioPath(IdentifierID) or RegisteredIdentifiers[IdentifierID]
end

function Identifiers.Clear() 
    RegisteredIdentifiers = {}
end

return Identifiers