print("Please Wait...")
require("Shared")

MYFPSCAPPER9001 = love.timer.getTime()

function love.load(args)
    love.graphics.clear(0.5,0.5,0.5)
    love.graphics.present()
    
    Shared.SetupBullet = require("Shared.SetupGlobals")()

    if FLAGS.Compat then
        print("StudioDream is running in compatability mode, expect crashes or graphics issues")
    end
    
    print("StudioDream V"..VERSION..", Target: "..FLAGS.ModeTarget)

    Shared.Init(args)

    print("Runtime is ready.")

    --love.graphics.captureScreenshot("Welcome ".. os.time() .. ".png")

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))

    MYFPSCAPPER9001 = love.timer.getTime()
end

local DeltaTime
local DebugFont = love.graphics.newFont()

function love.draw()
    Shared.Render()

    love.graphics.setFont(DebugFont)
    love.graphics.print(tostring(math.round(1/DeltaTime)).." FPS", love.graphics:getWidth()-50, 0)

    local MYFPSINATOR = love.timer.getTime()
    if MYFPSCAPPER9001 <= MYFPSINATOR then
        MYFPSCAPPER9001 = MYFPSINATOR
        return
    end
    love.timer.sleep(MYFPSCAPPER9001 - MYFPSINATOR)
end

function love.update(dt)
    MYFPSCAPPER9001 = MYFPSCAPPER9001 + 1/60

    Shared.Update(dt)
    
    DeltaTime = dt
end

