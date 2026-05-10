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

    Runtime.Backend.PostInit()

    Runtime.Serializer = require("Runtime.Serialization")

    Profiler = Dream.delton

    print("Runtime Initalized")
end

function Runtime.Render()
    Runtime.Renderer.Render()

    Dream:presentDebug()
end

function Runtime.Update(dt)
    Profiler:start("StudioDream - Update")

        require("Shared").Update(dt) -- this garbage was probably me :3 - bloctans
        Runtime.Backend.Update(dt)
        Runtime.Renderer.ViewportManager.Update(dt) -- temporary
        Runtime.Things.Update(dt)

    Profiler:stop()
end

return Runtime