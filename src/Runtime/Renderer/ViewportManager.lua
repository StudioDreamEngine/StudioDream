local Things
local ViewportManager = {}

local TestCamera = require("Runtime.Backend.cameraController")

function ViewportManager.Init()
    Things = Runtime.Things

    ViewportManager.Viewports = {}
end

function ViewportManager.CreateViewport(Viewport, Size)
    local Canvas = Runtime.Backend2D.NewCanvas(Size)
    ViewportManager.Viewports[Viewport.UUID] = Viewport
    return Canvas
end

-- Render the contents of a 2d viewport
function ViewportManager.RenderViewport2D(Viewport)
    Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
        love.graphics.clear()

        for _, Element in pairs(Viewport.DisplayList) do
            love.graphics.push()

            love.graphics.replaceTransform(Element.Transform)
            Element.Child:DrawStyle()
            love.graphics.pop()
        end

        love.graphics.circle("fill", Viewport.MousePosition.X, Viewport.MousePosition.Y, 10)
        love.graphics.rectangle("line", 0,0,Viewport.AbsoluteSize.X, Viewport.AbsoluteSize.Y)
    end)
end

-- Render the contents of a 3d viewport
function ViewportManager.RenderViewport3D(Viewport)
    Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
        Dream:prepare()
        love.graphics.clear()

        TestCamera:setCamera(Dream.camera)

        for _, Element in pairs(Viewport.DisplayList) do
            Dream:draw(Element.Child)
        end

        Dream:present()
    end)
end

-- Render the canvas itself to the screen
function ViewportManager.RenderCanvas(Viewport) Runtime.Backend2D.RenderCanvas(Viewport.ViewportCanvas) end

function ViewportManager.Update(dt)
    Dream:update(dt)
end

function ViewportManager.Render()
    for _, Viewport in pairs(ViewportManager.Viewports) do
        if Viewport:IsA("Viewport2D") then
            ViewportManager.RenderViewport2D(Viewport)
        else
            ViewportManager.RenderViewport3D(Viewport)
        end
    end

    local RootViewport = Things.Root.Viewport
    ViewportManager.RenderCanvas(RootViewport)

    RootViewport.Size = Pivot2D.FromOffset(Runtime.Backend2D.GetWindowSize())
end

return ViewportManager