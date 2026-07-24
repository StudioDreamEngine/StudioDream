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
    
    Render.ClassText = require("Runtime.Renderer.Class.Text")
    Render.Image = require("Runtime.Renderer.Class.Image")
end

function Render.Render()
    Profiler.Start("StudioDream - Render Viewports")
        Render.ViewportManager.Render()
    Profiler.End()
end

return Render