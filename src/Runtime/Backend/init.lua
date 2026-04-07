-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Renderer, Input handling, etc
local Backend = {}

function Backend.Get2DBackend()
    return require("Runtime.Backend.LoveBackend")
end

function Backend.Init()
    
end

return Backend