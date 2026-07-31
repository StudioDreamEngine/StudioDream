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
Shared.AbortQueue = {}

FLAGS = DEFAULT_FLAGS
FLAGS.SecondRun = false
FLAGS.TargetProject = nil

function Shared.QueueAbort(Msg)
    printVerbose(Msg)
    printVerbose(debug.traceback())

    for _, Line in pairs(string.split(Msg, "\n")) do
        table.insert(Shared.AbortQueue, Line)    
    end
    
    return true -- Return true, as that can be used to identify that something has errored
end

function Shared.ProcessQueue()
    if #Shared.AbortQueue > 0 then
        Shared.AbortAPI(table.concat(Shared.AbortQueue, "\n"))
        Shared.AbortQueue = {}
    end
end

function Shared.SaveLog(Msg)
    print(Msg)
    love.filesystem.write("Log.txt", Msg)
    print("(Log has been saved to Log.txt)")
end

Shared.AbortAPI = function(Msg)
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
    --FLAGS = require("Shared.CommandParser")()

    -- Merge Polyfill flags and regular flags
    for i,_ in pairs(POLYFILL_FLAGS) do
        if FLAGS[i] then POLYFILL_FLAGS[i] = FLAGS[i] end
    end

    print("Target Chosen: "..FLAGS.Target)
    
    --Shared.Theme = require("Shared.Theme") -- mikl please NEVER put random studio shit in shared

    printVerbose("Shared Components ready, Setup Runtime")
    Runtime = require("Runtime")
    Runtime.Init()

    -- TODO: Move to runtime
    local Thing = love.image.newImageData("/Assets/Icons/"..FLAGS.Target..".png")
    love.window.setIcon(Thing)

    Shared.Splash = require("Shared.Splash")
    Shared.Splash.Create()

    Scheduler.NewTask(Shared.Splash.Load)
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

        Shared.UpdateTarget(dt)
    Profiler.End()
end

-- Target-Related stuff
local Target

function Shared.StartTarget()
    ---@module "Studio"
    Target = require(FLAGS.Target)
    Target.Init() 
end

function Shared.UpdateTarget(dt)
    if not Target then return end
    
    if (GlobalTick - LastQueue) > 1 then
        Shared.ProcessQueue()
        LastQueue = GlobalTick
    end

    Target.Update(dt)
end

return Shared