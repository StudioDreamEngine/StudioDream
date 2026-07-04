Shared = {}

-- Configure CPath
local CurrentOS = love.system.getOS()

local Extensions = {
    Linux = "so",
    Windows = "dll"
}

package.cpath = package.cpath..";./CLibraries/"..string.lower(CurrentOS).."/?."..Extensions[CurrentOS]

--Start actual stuff
local LastQueue = 0
local StartedTarget = false

Shared.AbortAPI = nil
Shared.AbortQueue = {}

Shared.SkipSplash = false

function Shared.QueueAbort(Msg)
    printVerbose(Msg)
    printVerbose(debug.traceback())

    table.insert(Shared.AbortQueue, Msg)
    return true -- Return true, as that can be used to identify that something has errored
end

function Shared.ProcessQueue()
    if #Shared.AbortQueue > 0 then
        Shared.AbortAPI(table.concat(Shared.AbortQueue, "\n"))

        Shared.AbortQueue = {}
    end
end

function Shared.Abort(Msg)
    print("ABORTED: "..Msg)
    os.exit(-1)
end

--[[
    Args:
        1: Mode target
        2: Project
        3: Verbose mode
]]
function Shared.Init(Args)
    print(Args)

    local SharedInit = Profiler.Benchmark("Shared - Init", true)

    if Args[3] then 
        print("Verbose flag is true, Enabling verbose debugging")
        POLYFILL_FLAGS.Verbose = true 
    end

    Shared.SkipSplash = Args[2] and true or false
    Shared.Target = Args[1] or FLAGS.ModeTarget

    local Thing = love.image.newImageData("/Assets/Icons/"..Shared.Target..".png")
    love.window.setIcon(Thing)

    printVerbose("Shared Components ready, Setup Runtime")
    Runtime = require("Runtime")
    Runtime.Init()

    if (not Utils.FileExists(Shared.Target)) then
        Shared.Abort("Invalid Target: "..Shared.Target)
    end

    printVerbose("Start splash")
    Shared.Splash = require("Shared.Splash")
    Shared.Splash.Create()
    Scheduler.NewTask(Shared.Splash.Load, Args[2])

    SharedInit.End()
end

function Shared.Render()
    Runtime.Render()
end

function Shared.Update(dt)
    GlobalTick = GlobalTick + dt

    Profiler.Start("StudioDream - Update")
        Scheduler.Update()
        Runtime.Update(dt)

        if StartedTarget then
            Shared.UpdateTarget(dt)
        end
    Profiler.End()
end

-- Target-Related stuff
local Target

function Shared.StartTarget()
    ---@module "Studio"
    Target = require(Shared.Target)
    Target.Init()

    StartedTarget = true
end

function Shared.UpdateTarget(dt)
    if (GlobalTick - LastQueue) > 1 then
        Shared.ProcessQueue()
        LastQueue = GlobalTick
    end

    Target.Update(dt)
end

return Shared