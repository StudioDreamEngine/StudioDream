local Things
local ViewportManager = {}

local TestCamera = Editor.Camera

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
            love.graphics.translate(Element.Child.AbsolutePosition.X,Element.Child.AbsolutePosition.Y)
            Element.Child:DrawStyle()
            love.graphics.pop()
        end

        love.graphics.circle("fill", Viewport.MousePosition.X, Viewport.MousePosition.Y, 10)
    end)
end

-- Render the contents of a 3d viewport
function ViewportManager.RenderViewport3D(Viewport)
    Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
        Dream:prepare()

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
    TestCamera:update(dt,75)
    Dream:update(dt)
end

function love.resize(w,h)
    local RootViewport = Things.Root.Viewport
    RootViewport:SetSize(Pivot2D.FromOffset(w,h))
end

function ViewportManager.Render()
    Profiler:start("Render Viewports")
        for _, Viewport in pairs(ViewportManager.Viewports) do
            if Viewport:IsA("Viewport2D") then
                Profiler:start("2D Viewport")
                ViewportManager.RenderViewport2D(Viewport)
                Profiler:stop()
            else
                ViewportManager.RenderViewport3D(Viewport)
            end
        end
    Profiler:stop()

    local RootViewport = Things.Root.Viewport
    ViewportManager.RenderCanvas(RootViewport)
end

return ViewportManager