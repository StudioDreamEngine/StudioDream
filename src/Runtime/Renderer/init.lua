local Render = {}

Render.ViewportManager = require("Runtime.Renderer.ViewportManager")

local Backend3D

function Render.Get2DBackend()
    return require("Runtime.Renderer.LoveBackend")
end

function Render.Get3DBackend()
    return require("Runtime.Renderer.Backend3D")
end

function Render.Init()
    Backend3D = Runtime.Backend3D
    Backend3D.Init()

    Render.ViewportManager.Init()
end

function Render.Render()
    Profiler:start("StudioDream - Render Viewports")
        Render.ViewportManager.Render()
    Profiler:stop()
end

return Render