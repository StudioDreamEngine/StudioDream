local ResourceService = {}

ResourceService.GetIdentifier = Runtime.Resources.GetIdentifier
ResourceService.UnloadIdentifier = Runtime.Resources.UnregisterIdentifier

ResourceService.LoadScene = Runtime.Project.Scenes.LoadScene

-- Loads a new scene as the current loaded enviornment, SceneID is an Identifier ID.
function ResourceService.ChangeScene(SceneID)
    Runtime.Project.LoadEnviornment(SceneID)
end

-- Buffers

-- Create a buffer object and return its Identifier ID
function ResourceService.CreateBuffer(Data)
    return Runtime.Resources.CreateBuffer(Data).ID
end

-- Change the data being used by this buffer
function ResourceService.ChangeBufferReference(IdentifierID, NewReference)
    Runtime.Resources.ChangeBuffer(IdentifierID, NewReference)
end

return ResourceService