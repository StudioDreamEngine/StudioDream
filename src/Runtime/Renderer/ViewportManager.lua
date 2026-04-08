local Things
local ViewportManager = {}

function ViewportManager.Init()
    Things = Runtime.Things

    ViewportManager.Viewports = {}
    ViewportManager.RenderQueue = {} 
end

function ViewportManager.CreateViewport(Viewport, Size)
    local Canvas = Runtime.Backend2D.NewCanvas(Size)

    ViewportManager.Viewports[Viewport.UUID] = {
        Canvas = Canvas,
        Viewport = Viewport
    }

    return Canvas
end

function ViewportManager.RenderViewport(Viewport)
    for _, Element in pairs(Viewport.DisplayList) do
        love.graphics.push()

        love.graphics.origin()
        local AbsolutePosition = Element.Child:GetAbsolutePosition()
        local AbsoluteSize = Element.Child.AbsoluteSize
        love.graphics.rectangle("line", AbsolutePosition.X, AbsolutePosition.Y, AbsoluteSize.X, AbsoluteSize.Y)

        love.graphics.replaceTransform(Element.Transform) -- for now
        Element.Child:DrawStyle()
        love.graphics.pop()
    end
end

function ViewportManager.Render()
    for _, Viewport in pairs(ViewportManager.Viewports) do
        Runtime.Backend2D.CanvasCall(Viewport.Canvas, function()
            ViewportManager.RenderViewport(Viewport.Viewport)
        end)
    end

    local RootViewport = Things.Root.Viewport
    Runtime.Backend2D.RenderCanvas(RootViewport.ViewportCanvas)
end

return ViewportManager