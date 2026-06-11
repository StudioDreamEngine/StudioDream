local Shared = {}

-- Configure CPath
local CurrentOS = love.system.getOS()

local Extensions = {
    Linux = "so",
    Windows = "dll"
}

package.cpath = package.cpath..";./CLibraries/"..string.lower(CurrentOS).."/?."..Extensions[CurrentOS]

--Start actual stuff
local StartedTarget = false

function Shared.Init()
    local SharedInit = Profiler.Benchmark("Shared - Init", true)

    print("Shared Components ready, Setup Runtime")
    Runtime = require("Runtime")
    Runtime.Init()

    Shared.Target = love.restart or FLAGS.ModeTarget

    print("Start splash")
    Shared.Splash = require("Shared.Splash")
    Shared.Splash.Init()

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
    Target.Update(dt)
end

return Shared