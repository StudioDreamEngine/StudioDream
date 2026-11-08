local Methods = {}

function Methods:Serialize(Data)
    return JSON.encode(Data)
end

function Methods:Deserialize(Data)
    return JSON.decode(Data)
end

return function(Config)
    return setmetatable({
        Config = Config
    }, {
        __index = Methods
    })
end