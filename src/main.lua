print("Please Wait...")
Shared = require("Shared")

function love.load()
    love.graphics.clear(0.5,0.5,0.5)
    love.graphics.present()
    
    Shared.SetupBullet = require("Shared.SetupGlobals")()
    
    print("StudioDream V"..VERSION..", Target: "..FLAGS.ModeTarget)

    Shared.Init()

    print("Runtime is ready.")

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))
end

local DeltaTime
local DebugFont = love.graphics.newFont()

function love.draw()
    Shared.Render()

    love.graphics.setFont(DebugFont)
    love.graphics.print(tostring(math.round(1/DeltaTime)).." FPS", 0, love.graphics:getHeight()-12)
end

function love.update(dt)
    Shared.Update(dt)
    
    DeltaTime = dt
end

