local Things
local ViewportManager = {}

local LoveBackend = require("Runtime.Renderer.LoveBackend")

function ViewportManager.Init()
    Things = Runtime.Things

    ViewportManager.Viewports = {}
    ViewportManager.RenderQueue = {} 
end

function ViewportManager.CreateViewport(Viewport, Size)
    local Canvas = LoveBackend.NewCanvas(Size)

    ViewportManager.Viewports[Viewport.UUID] = {
        Canvas = Canvas,
        Viewport = Viewport
    }

    return Canvas
end

function ViewportManager.RenderViewport(Viewport)
    for _, Element in pairs(Viewport.DisplayList) do
        Element.Child:Draw()
    end
end

function ViewportManager.Render()
    for _, Viewport in pairs(ViewportManager.Viewports) do
        LoveBackend.CanvasCall(Viewport.Canvas, function()
            ViewportManager.RenderViewport(Viewport.Viewport)
        end)
    end

    local RootViewport = Things.Root.Viewport
    LoveBackend.RenderCanvas(RootViewport.ViewportCanvas)
end

return ViewportManager