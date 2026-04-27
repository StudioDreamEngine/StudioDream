Shared = require("Shared")

local Target = require("Editor")

function love.load()
    require("Shared.SetupGlobals")()
    
    Target.Init()

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursor.png", 0,0))
end

local DeltaTime
local DebugFont = love.graphics.newFont()

function love.draw()
    Target.Render()

    love.graphics.setFont(DebugFont)
    love.graphics.print(tostring(math.round(1/DeltaTime)).." FPS", 0, love.graphics:getHeight()-12)
end

function love.update(dt)
    Target.Update(dt)
    Shared.Update(dt)
    
    DeltaTime = dt
end

