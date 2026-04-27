local Runtime = {}

-- Configure CPath
local CurrentOS = love.system.getOS()

local Extensions = {
    Linux = "so",
    Windows = "dll"
}

package.cpath = package.cpath..";./CLibraries/"..string.lower(CurrentOS).."/?."..Extensions[CurrentOS]

Runtime.Things = require("Runtime.Things")
Runtime.Renderer = require("Runtime.Renderer")
Runtime.Backend = require("Runtime.Backend")

function Runtime.Init()
    Runtime.Backend.Init()

    Runtime.Backend2D = Runtime.Renderer.Get2DBackend()
    Runtime.Backend3D = Runtime.Renderer.Get3DBackend()

    Runtime.Renderer.Init()
    Runtime.Things.Init()

    Runtime.Serializer = require("Runtime.Serialization")

    Profiler = Dream.delton
end

function Runtime.Render()
    Profiler:start("StudioDream Runtime - Render")

        Runtime.Renderer.Render()

    Profiler:stop()

    Dream:presentDebug()
end

function Runtime.Update(dt)
    Profiler:start("StudioDream Runtime - Update")

        require("Shared").Update(dt)
        Runtime.Backend.Update(dt)
        Runtime.Renderer.ViewportManager.Update(dt) -- temporary
        Runtime.Things.Update(dt)

    Profiler:stop()
end

return Runtime