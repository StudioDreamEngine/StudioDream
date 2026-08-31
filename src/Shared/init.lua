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
    printVerbose("UUID Seed: "..UUIDSeed)

    PROF_CAPTURE = FLAGS.ProfileCapture
    Jprof = require("Shared.Packages.jprof")

    if PROF_CAPTURE then
        Jprof.connect(true)
    end
    
    --Shared.Theme = require("Shared.Theme") -- mikl please NEVER put random studio shit in shared

    printVerbose("Shared Components ready, Setup Runtime")
    Runtime = require("Runtime")
    Runtime.Init()

    printVerbose("Runtime ready, creating splash")

    -- TODO: Move to runtime
    local Thing = love.image.newImageData("/Assets/Icons/"..FLAGS.Target..".png")
    love.window.setIcon(Thing)

    Shared.OnQuit = Signal:New("IQUITIT!")

    Shared.Splash = require("Shared.Splash")
    Shared.Splash.Create()

    Scheduler.NewTask(Shared.Splash.Load)

    SharedInit.End()
end

function Shared.Render()
    Runtime.Render()

    if love.keyboard.isDown(".") then
        Shared.RenderStats()
    end
end

local Tooltips = {}


function Shared.RenderStats()
    local Stats = love.graphics.getStats()
    local ThingStats = Runtime.Things.GetCount()
    local MousePos = Runtime.Backend2D.GetMousePosition()

    local DebugStats = {
        { Name = "(Love) FPS",                                                                                                                                  Value = love.timer.getFPS() },
        { Name = "(Love) Loaded Textures",                                                                                                                      Value = Stats.textures },
        { Name = "(Love) Loaded Fonts",                                                                                                                         Value = Stats.fonts },
        { Name = "(Love) Texture Memory",                                                                                                                       Value = tostring(math.round(Stats.texturememory/1000000)).."mb" },
        { Name = "(Love) Mouse position",                                                                                                                       Value = tostring(MousePos) },
        { Name = "(GPU) Draw Calls",                    Help = "The amount of objects LOVE has sent to the gpu itself",                                         Value = Stats.drawcalls },
        { Name = "(GPU) Draw Calls (Batched)",          Help = "Batching is a process where several simillar draw calls are sent to the gpu at once",           Value = Stats.drawcallsbatched },
        { Name = "(Runtime) Object Count",                                                                                                                      Value = ThingStats.Objects },
        { Name = "(Runtime) Rendered",                  Help = "The amount of objects ViewportManager has counted as rendered since the start of the frame",    Value = Runtime.Renderer.ViewportManager.GetRendered() },
        { Name = "(Runtime) Invalidations This Frame",  Help = "How many ui objects have had their positions and size on screen re-calculated this frame",      Value = ThingStats.Invalidated },
        { Name = "(Runtime) Is Profiling",                                                                                                                      Value = FLAGS.ProfileCapture },
        { Name = "(Runtime) Scheduler Tasks",                                                                                                                   Value = Scheduler.GetTasks() },
        { Name = "(Runtime) Orphaned - Destroyed",      Help = "Objects that have been destroyed, but still have a reference and thus are still in memory.",    Value = ThingStats.Orphans },
        { Name = "(Runtime) Orphaned - Unparented",     Help = "Objects that are not parented, but havent been destroyed, and thus are still in memory.",       Value = ThingStats.ScriptOrphans },
        { Name = "(Lua) Heap Size",                     Help = "How much memory StudioDream itself is taking up in the lua vm",                                 Value = math.round(collectgarbage("count")).."kb" }
    }

    love.graphics.setFont(DebugFont)
    local DebugString = ""

    for Index, Stat in pairs(DebugStats) do
        if Stat.Help and (not Tooltips[Index]) then
            Tooltips[Index] = {
                Str = Stat.Help,
                Rect = Rect.new(Vector2.new(0,(Index-1)*16), Vector2.new(400,20))
            }
        end

        DebugString = DebugString .. Stat.Name .. ": " .. tostring(Stat.Value) .. "\n"
    end

    --Profiler.Render()
    local Flexed = 0
    local Total = 0
    --print(Runtime.Things.CollectOrphans())
    for i in string.gmatch(ThingStats.Orphans,"%S+") do
        if string.find(i,"Flex") then
            Flexed=Flexed+1
        end
        if not string.find(i,"%(") then
            Total=Total+1
        end
    end
    printVerbose("The Flex entities exploring aroud :"..Flexed.." Normal Orphans exploring around: "..Total.." The math shit:"..(Total-Flexed))

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, 250,300)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(DebugString, 0, 0)

    for Index, Tooltip in pairs(Tooltips) do
        if Utils.IntersectPoint2D(Tooltip.Rect, MousePos) then
            local Width, Wrapped = DebugFont:getWrap(Tooltip.Str, 200)

            love.graphics.push()
            love.graphics.translate(MousePos.X+20, MousePos.Y)
            love.graphics.setColor(0,0,0,1)
            love.graphics.rectangle("fill", 0, 0, Width, (#Wrapped) * 16)
            love.graphics.setColor(1,1,1,1)
            love.graphics.printf(Tooltip.Str, 0,0, Width)
            love.graphics.pop()
        end
    end
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

function Shared.UpdateTarget(dt)
    if not Target then return end
    
    if (GlobalTick - LastQueue) > 1 then
        Shared.ProcessQueue()
        LastQueue = GlobalTick
    end

    Target.Update(dt)
end

return Shared