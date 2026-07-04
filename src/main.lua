print("Please Wait...")
require("Shared")

MYFPSCAPPER9001 = love.timer.getTime()
function love.load(args)
    local OldGetDirectoryItems = love.filesystem.getDirectoryItems

    love.filesystem.getDirectoryItems = function (dir)
        local Result = OldGetDirectoryItems(dir)
        if Result[1] == "" then Result = {} end

        return Result
    end

    love.graphics.clear(0.5,0.5,0.5)
    love.graphics.present()
    
    Shared.SetupBullet = require("Shared.SetupGlobals")()
    
    print("StudioDream V"..VERSION_FULL..", Configured Target: "..FLAGS.ModeTarget)

    Shared.Init(love.restart or args)

    print("Runtime is ready.")

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))
    MYFPSCAPPER9001 = love.timer.getTime()
end

local ERROR_SEPERATE = "---------------------------------------------------------------------------------------"

function love.errorhandler(msg)
    local traceback = debug.traceback(msg)

    print(traceback)

    local crash_extra = "Operating System: "..love.system.getOS()

    local success, msg = pcall(Runtime.OnCrash)
    
    if (not success) then
        crash_extra = crash_extra.."\nCouldnt save project: "..msg
    end

    local full_trace = crash_extra.."\n"..ERROR_SEPERATE.."\n"..traceback

    -- I'd make this a little better, but eh its fine enough for now
    love.system.setClipboardText(full_trace)

    love.graphics.origin()
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())

    love.graphics.setColor(1,0.2,0.2)

    love.graphics.setFont(love.graphics.newFont(14))
    local y = 5
    local function Log(msg)
        love.graphics.print(msg or "", 5, y)
        y = y + 20
    end

    Log("Something happened!")
    Log("The error has been copied to your clipboard, Press ESC to exit.")
    Log()
    for i,v in pairs(string.split(full_trace, "\n")) do
        Log(v)
    end
    love.graphics.present()

    return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
            elseif e == "keypressed" and a == "escape" then
				return 1
			end
		end

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
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

