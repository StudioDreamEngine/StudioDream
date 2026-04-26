Shared = require("Shared")
Runtime = require("Runtime")
Editor = require("Editor")

function love.load()
    Shared.Init()
    Runtime.Init()
    Editor.Init()

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursor.png", 0,0))
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

