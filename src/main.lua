print("Please Wait...")
Shared = require("Shared")

---@module "Studio"
local Target = require(FLAGS.ModeTarget)

function love.load()
    require("Shared.SetupGlobals")()
    
    print("StudioDream V"..VERSION..", Target: "..FLAGS.ModeTarget)
    print("Shared Components ready, Initalizing Target")

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

