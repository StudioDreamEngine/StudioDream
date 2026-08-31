local Serializer = {}

function Serializer.Serialize(Value)
    if Value.ResourceType == "Buffer" then
        printVerbose("Attempted to serialize buffer resource")
        return
    end

    return Value
end

function Serializer.Deserialize(Value)
    if string.find(Value, "[%{%}]") then
        Runtime.Resources.RegisterAsMissing(Value, true)
        return
    end

    local Identifier = Runtime.Resources.GetIdentifierFromID(Value)

    if (not Identifier) then
        Runtime.Resources.RegisterAsMissing(Value)
        return
    end

    return Identifier
end

return Serializer