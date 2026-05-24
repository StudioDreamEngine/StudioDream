print("Please Wait...")
Shared = require("Shared")

function love.load()
    require("Shared.SetupGlobals")()
    
    print("StudioDream V"..VERSION..", Target: "..FLAGS.ModeTarget)
    print("Shared Components ready, Initalizing Target")

    Shared.StartTarget()

    print("Target is ready.")

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))
    local StartSound = love.audio.newSource("/Assets/DefaultSounds/Jingle.wav", "static")
    love.audio.play(StartSound)
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

