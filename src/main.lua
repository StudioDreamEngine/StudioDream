Shared = require("Shared")
Editor = require("Editor")
Runtime = require("Runtime")

function love.load()
    Shared.Init()
    Runtime.Init()
    Editor.Init()
end

local DeltaTime
local DebugFont = love.graphics.newFont()

function love.draw()
    Runtime.Render()
    Editor.Render()

    love.graphics.setFont(DebugFont)
    love.graphics.print(tostring(math.round(1/DeltaTime)).." FPS", 0, love.graphics:getHeight()-12)
end

function love.update(dt)
    Editor.Update(dt)
    Runtime.Update(dt)
    Shared.Update(dt)
    
    DeltaTime = dt
end

