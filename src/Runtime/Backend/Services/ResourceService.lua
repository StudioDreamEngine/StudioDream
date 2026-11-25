local ResourceService = {}

function ResourceService.Init() end

function ResourceService:LoadScene(Identifier)
    return Runtime.Project.Scenes.LoadScene(Identifier)
end

function ResourceService:UnloadIdentifier(Identifier)
    return Runtime.Resources.UnregisterIdentifier(Identifier)
end

function ResourceService:GetResourceByPath(Path)
    Utils.AssertType(Path,"string")
    local Identifier = self:GetIdentifierFromID(Path)
    assert(Identifier,"Idenfier coulnt be loaded! Check if the path is correct!")
    return self:LoadResourceFromIdentifier(Identifer)
end

function ResourceService:GetIdentifierFromID(ID)
    Utils.AssertType(ID,"string")

    return Runtime.Resources.GetIdentifierFromID(ID)
end

function ResourceService:LoadResourceFromIdentifier(Identifer)
    Utils.AssertType(Identifer,"Identifer")

    return Runtime.Resources.LoadResourceFromIdentifier(Identifer)
end

-- Loads a new scene as the current loaded enviornment, SceneID is an Identifier ID.
function ResourceService:ChangeScene(SceneID)
    Utils.AssertType(ID,"string")

    Runtime.Project.LoadEnviornment(SceneID)
end

-- Buffers

-- Create a buffer object and return its Identifier ID
function ResourceService:CreateBuffer(Data)
    return Runtime.Resources.CreateBuffer(Data).ID
end

-- Change the data being used by this buffer
function ResourceService:ChangeBufferReference(IdentifierID, NewReference)
    Runtime.Resources.ChangeBuffer(IdentifierID, NewReference)
end

return ResourceService