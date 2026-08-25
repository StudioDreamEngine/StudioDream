print("Please Wait...")
require("Shared")

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
    ---@diagnostic disable-next-line: lowercase-global
    raw_pairs = pairs
    pairs = function(t) -- todo: possibility of adding to luaupolyfill
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

local dbglog = {}

function DebugLog(msg)
    love.graphics.setFont(DebugFont)
    love.graphics.clear(0.1,0.1,0.3)
    love.graphics.setColor(1,1,1)

    if #dbglog > 40 then
        table.remove(dbglog, 1)
    end

    table.insert(dbglog, "["..os.clock().."] "..msg)

    love.graphics.print(table.concat(dbglog, "\n"), 6, 0)
    love.graphics.present()
end

function love.load(args)
    SetupModifications()

    DebugLog("StudioDream V"..VERSION_FULL..", Setting up globals")
    Shared.SetupBullet = require("Shared.SetupGlobals")()
    print("StudioDream V"..VERSION_FULL)

    DebugLog("Starting runtime, hold on!")

    Shared.Init(love.restart or args)

    print("Runtime is ready.")

    love.mouse.setCursor(love.mouse.newCursor("/Assets/Cursors/Main.png", 0,0))
    MYFPSCAPPER9001 = love.timer.getTime()
    DebugLog("Ready!")
end

local ERROR_SEPERATE = "---------------------------------------------------------------------------------------"

function love.errorhandler(msg)
    local traceback = debug.traceback(msg)

    print(traceback)

    local crash_extra = "Operating System: "..love.system.getOS()

    local success, msg = pcall(Runtime.OnCrash)
    
    if (not success) then
        crash_extra = crash_extra.."\nCouldnt save project: "..msg.."\n(ABOVE ONLY APPEARS WHEN THE CRASH CALLBACK FAILS, IT IS NOT THE ERROR!)"
    else
        crash_extra = crash_extra.."\nProject was successfully saved"
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

    DebugLog("")
    DebugLog("Something happened! (Non-Recoverable Error)")
    DebugLog("The error has been copied to your clipboard, Press ESC to exit.")
    DebugLog("")
    for i,v in pairs(string.split(full_trace, "\n")) do
        DebugLog(v)
    end

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

    Profiler.End("frame")
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
    printVerbose("Gracefully shutting down StudioDream...")

    Profiler.Frame = true
    Profiler.Start("frame")

    Shared.OnQuit.Invoke()
    Runtime.Services.OnQuit() -- this FUCKING sucks!!! :3

    love.filesystem.write("Latest.log", table.concat(PrintLogs, "\n"))
    print("Saved logs, You can find Latest.log at "..love.filesystem.getAppdataDirectory())
    Profiler.End("frame")

    Profiler.Quit()
end