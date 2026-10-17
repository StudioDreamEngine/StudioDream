local Render = {}

Render.ViewportManager = require("Runtime.Renderer.ViewportManager")

-- Get the Love2D backend utilities
function Render.Get2DBackend()
    return require("Runtime.Renderer.LoveBackend")
end

-- Get the 3DreamEngine backend Utilities
function Render.Get3DBackend()
    return require("Runtime.Renderer.Backend3D")
end

function Render.GetShaders()
    return require("Runtime.Renderer.Shaders")
end

function Render.Init()
    Render.ViewportManager.Init()
    
    -- Define the render classes, simple utility modules for rendering 3d and 2d elements
    -- TODO: Document
    Render.Text = require("Runtime.Renderer.Class.Text")
    Render.Image = require("Runtime.Renderer.Class.Image")
    Render.Billboard = require("Runtime.Renderer.Class.Billboard")
    Render.Input = require("Runtime.Renderer.Class.Input")
end

function Render.Render()
    Profiler.Start("StudioDream - Render Viewports")
        Render.ViewportManager.Render()

        if FLAGS.DebugDraw and Runtime.InterfaceManager then  
            Runtime.InterfaceManager.DebugDraw()
        end
    Profiler.End()
end

return Render