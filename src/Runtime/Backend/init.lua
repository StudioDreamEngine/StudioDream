-- Basically anything that needs to be rendered or whatever seperate from things
-- Services, Script Handler, Input handling, etc
local Backend = {}

function Backend.Init()
    Runtime.InterfaceManager = require("Runtime.Backend.InterfaceManager")
    Runtime.InterfaceManager.Init()

    Runtime.ScriptUtil = require("Runtime.Backend.ScriptUtility")
    Runtime.ObjectProxy = require("Runtime.Backend.ObjectProxy")

    Runtime.Services = {}
    Runtime.Services.InputService = require("Runtime.Backend.Services.InputService")
    Runtime.Services.Debug = require("Runtime.Backend.Services.Debug")
    Runtime.MouseHit = require("Runtime.Backend.MouseHit")
    Runtime.Services.InputService:Init()
    Runtime.MouseHit:Init()
    Runtime.Services.Debug:Init()
end

function Backend.Update(dt)
    Runtime.InterfaceManager.Update(dt)
    Runtime.Services.InputService:Update(dt)
    Runtime.MouseHit:Update()
end

function love.keypressed(Key)
    Runtime.Services.InputService:keypressed(Key)
end

function love.keyreleased(Key)
    Runtime.Services.InputService:keyreleased(Key)
end

function love.gamepadpressed(joy, Key)
    Runtime.Services.InputService:gamepadpressed(joy,Key)
end

function love.gamepadreleased(joy, Key)
    Runtime.Services.InputService:gamepadreleased(joy,Key)
end

function love.mousepressed(x,y,button,istouch)
     Runtime.Services.InputService:mousepressed(x,y,button,istouch)
end

function love.mousereleased(x,y,button,istouch)
     Runtime.Services.InputService:mousereleased(x,y,button,istouch)
end

return Backend