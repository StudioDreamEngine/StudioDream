local Shared = {}

-- Configure CPath
local CurrentOS = love.system.getOS()

local Extensions = {
    Linux = "so",
    Windows = "dll"
}

package.cpath = package.cpath..";./CLibraries/"..string.lower(CurrentOS).."/?."..Extensions[CurrentOS]

--Start actual stuff
Shared.Splash = require("Shared.Splash")

local Target

function Shared.StartTarget()
    Runtime = require("Runtime")
    Runtime.Init()

    ---@module "Studio"
    Target = require(FLAGS.ModeTarget)
    Target.Init()
end

function Shared.Render()
    Runtime.Render()
end

function Shared.UpdateRuntime(dt)
    GlobalTick = GlobalTick + dt
    Scheduler.Update()
end

function Shared.Update(dt)
    Target.Update(dt)
    Runtime.Update(dt)
end

return Shared