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

Shared.AbortAPI = function(Msg) end

function Shared.Init(Args)
    Args[-2] = nil; Args[-1] = nil -- Dumbass way to remove these args, its only 2 so yeah

    local SharedInit = Profiler.Benchmark("Shared - Init", true)
    local Error = require("Shared.CommandParser")(Args)
    if Error then 
        PrintOG(Error)
        os.exit(-1)
    end

    -- Merge Polyfill flags and regular flags
    for i,_ in pairs(POLYFILL_FLAGS) do
        if type(FLAGS[i]) ~= "nil" then POLYFILL_FLAGS[i] = FLAGS[i] end
    end

    print("Flags:",FLAGS)

    PROF_CAPTURE = FLAGS.ProfileCapture
    Jprof = require("Shared.Packages.jprof")
    
    --Shared.Theme = require("Shared.Theme") -- mikl please NEVER put random studio shit in shared

    printVerbose("Shared Components ready, Setup Runtime")
    Runtime = require("Runtime")
    Runtime.Init()

    printVerbose("Runtime ready, creating splash")

    -- TODO: Move to runtime
    local Thing = love.image.newImageData("/Assets/Icons/"..FLAGS.Target..".png")
    love.window.setIcon(Thing)

    Shared.Splash = require("Shared.Splash")
    Shared.Splash.Create()

    Scheduler.NewTask(Shared.Splash.Load)

    Shared.OnQuit = Signal:New("IQUITIT!")

    SharedInit.End()
end

function Shared.Render()
    Runtime.Render()

    if love.keyboard.isDown(".") then
        Shared.RenderStats()
    end
end

function Shared.RenderStats()
    local Stats = love.graphics.getStats()
    local ThingStats = Runtime.Things.GetCount()

    local DebugStats = {
        { Name = "(Love) FPS",                  Value = love.timer.getFPS() },
        { Name = "(Love) Loaded Textures",      Value = Stats.textures },
        { Name = "(Love) Loaded Fonts",         Value = Stats.fonts },
        { Name = "(Love) Texture Memory",       Value = tostring(math.round(Stats.texturememory/1000000)).."mb" },
        { Name = "(GPU) Draw Calls",            Value = Stats.drawcalls },
        { Name = "(GPU) Draw Calls (Batched)",  Value = Stats.drawcallsbatched },
        { Name = "(Runtime) Object Count",      Value = ThingStats.Objects },
        { Name = "(Runtime) Invalidations This Frame",      Value = ThingStats.Invalidated },
        { Name = "(Runtime) Is Profiling",      Value = FLAGS.ProfileCapture },
        { Name = "(Lua) Heap Size",             Value = math.round(collectgarbage("count")).."kb" }
    }

    love.graphics.setFont(DebugFont)
    local DebugString = ""

    for _, Stat in pairs(DebugStats) do
        DebugString = DebugString .. Stat.Name .. ": " .. tostring(Stat.Value) .. "\n"
    end

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, 250,200)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(DebugString, 0, 0)
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

    if FLAGS.Target == "Client" then
        Shared.OnQuit:Connect(Target.OnQuit)
    end
end

function Shared.PostStartTarget()
    Target.PostInit() 
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