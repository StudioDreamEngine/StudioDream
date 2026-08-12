print("Please Wait...")
require("Shared")

local stack

DebugFont = love.graphics.newFont(12)

local function SetupModifications()
    -- Fix issue where empty directories return nothing
    local OldGetDirectoryItems = love.filesystem.getDirectoryItems
    love.filesystem.getDirectoryItems = function (dir)
        local Result = OldGetDirectoryItems(dir)
        if Result[1] == "" then Result = {} end

        return Result
    end

    -- __pairs support (https://stackoverflow.com/questions/70466069/pairs-and-ipairs-metamethods-does-not-work-at-all)
    local raw_pairs = pairs
    pairs = function(t)
        local metatable = getmetatable(t)
        if metatable and metatable.__pairs then
            return metatable.__pairs(t)
        end
        return raw_pairs(t)
    end

    --popipopipop popipo
    --[[local oldpush, oldpop = love.graphics.push, love.graphics.pop

    stack = {}

    love.graphics.push = function(a,path)
        table.insert(stack, path or debug.traceback())
        oldpush(a)
    end

    love.graphics.pop = function(...)
        table.remove(stack)
        oldpop(...)
    end]]
end

function love.load(args)
    SetupModifications()

    love.graphics.clear(0.101,0.09,0.3)
    love.graphics.print("["..os.clock().."] StudioDream V"..VERSION_FULL..", Starting Runtime")
    love.graphics.present()

    Shared.SetupBullet = require("Shared.SetupGlobals")()
    print("StudioDream V"..VERSION_FULL)

    Shared.Init(love.restart or args)

    print("Runtime is ready.")

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))
    MYFPSCAPPER9001 = love.timer.getTime()
end

local ERROR_SEPERATE = "---------------------------------------------------------------------------------------"

function love.errorhandler(msg)
    local traceback = debug.traceback(msg)

    print(traceback)
    print(stack)

    local crash_extra = "Operating System: "..love.system.getOS()

    local success, msg = pcall(Runtime.OnCrash)
    
    if (not success) then
        crash_extra = crash_extra.."\nCouldnt save project: "..msg.."\n(ABOVE ONLY APPEARS WHEN THE CRASH CALLBACK FAILS, IT IS NOT THE ERROR!)"
    end

    local full_trace = crash_extra.."\n"..ERROR_SEPERATE.."\n"..traceback

    -- I'd make this a little better, but eh its fine enough for now
    love.graphics.setCanvas()
    love.graphics.reset()

    love.system.setClipboardText(full_trace)

    love.graphics.origin()
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())

    love.graphics.setColor(1,0.2,0.2)

    love.graphics.setFont(DebugFont)
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

function love.draw()
    Shared.Render()
    Profiler.End()
    Profiler.Frame = false
    local MYFPSINATOR = love.timer.getTime()
    if MYFPSCAPPER9001 <= MYFPSINATOR then
        MYFPSCAPPER9001 = MYFPSINATOR
        return
    end

    love.timer.sleep(MYFPSCAPPER9001 - MYFPSINATOR)
end

function love.update(dt)
    Profiler.Frame = true
    Profiler.Start("frame")
    MYFPSCAPPER9001 = MYFPSCAPPER9001 + 1/60

    Shared.Update(dt)
    
    if FLAGS.AlwaysCollect then collectgarbage("collect") end
end

function love.quit()
    Profiler.Frame = true
    Profiler.Start("frame")

    Shared.OnQuit.Invoke()
    Runtime.Services.OnQuit() -- this FUCKING sucks!!! :3
    print("Closing and Saving logs...")
    love.filesystem.write("Latest.log", table.concat(PrintLogs, "\n"))
    Profiler.End()

    Profiler.Quit()
end