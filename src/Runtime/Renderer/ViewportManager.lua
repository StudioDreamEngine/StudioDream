local Things
local ViewportManager = {}

function ViewportManager.Init()
    Things = Runtime.Things

    ViewportManager.Viewports = {}
    ViewportManager.RenderQueue = {} 
end

function ViewportManager.CreateViewport(Viewport, Size)
    local Canvas = Runtime.Backend2D.NewCanvas(Size)

    ViewportManager.Viewports[Viewport.UUID] = Viewport
    return Canvas
end

-- Render the contents of a viewport
function ViewportManager.RenderViewport(Viewport)
    Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
        love.graphics.clear()

        for _, Element in pairs(Viewport.DisplayList) do
            love.graphics.push()

            local AbsolutePosition = Element.Child:GetDisplayPosition()
            local AbsoluteSize = Element.Child.AbsoluteSize

            love.graphics.rectangle("line", AbsolutePosition.X, AbsolutePosition.Y, AbsoluteSize.X, AbsoluteSize.Y)

            love.graphics.replaceTransform(Element.Transform)
            Element.Child:DrawStyle()
            love.graphics.pop()
        end

        love.graphics.circle("fill", Viewport.MousePosition.X, Viewport.MousePosition.Y, 1)
    end)
end

-- Render the canvas itself to the screen
function ViewportManager.RenderCanvas(Viewport)
    Runtime.Backend2D.RenderCanvas(Viewport.ViewportCanvas)
end

function ViewportManager.Render()
    for _, Viewport in pairs(ViewportManager.Viewports) do
        ViewportManager.RenderViewport(Viewport)
    end

    local RootViewport = Things.Root.Viewport
    ViewportManager.RenderCanvas(RootViewport)
end

return ViewportManager