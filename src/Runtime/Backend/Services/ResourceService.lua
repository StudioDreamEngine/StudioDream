local ResourceService = {}

ResourceService.GetIdentifier = Runtime.Resources.GetIdentifier
ResourceService.UnloadIdentifier = Runtime.Resources.UnregisterIdentifier

ResourceService.LoadScene = Runtime.Project.Scenes.LoadScene

-- Buffers
function ResourceService.CreateBuffer(Data)
    return Runtime.Resources.CreateBuffer(Data).ID
end

function ResourceService.ChangeBufferReference(IdentifierID, NewReference)
    Runtime.Resources.ChangeBuffer(IdentifierID, NewReference)
end

return ResourceService