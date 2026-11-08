local Methods = {}

function Methods:GetSerializer(Data)
    return NAML.Serialize()
end

function Methods:GetDeserializer(Data)
    return NAML.Deserialize(Data)
end

return function(Config)
    return setmetatable({}, {
        __index = Methods
    })
end