-- Manages the rendering and creation of viewports and canvases
local ViewportManager = {}

local RootViewport ---@class ViewportLite
local WindowViewport

Rendered = 0

function ViewportManager.Init()
    ViewportManager.Viewports = {}

    LoveEvents.Resize:Connect(function(w,h)
        --printVerbose("Resize detected, Updating Window decorations...")
        ViewportManager.UpdateSize()
    end)
end

function ViewportManager.UpdateSize()
    local Size = Runtime.Backend2D.GetWindowSize()
    local WindowManager = Runtime.WindowManager

    WindowViewport:SetSize(Pivot2D.FromOffset(Size.X, Size.Y))

    if WindowManager.Bar.Enabled then
        Size = Size - (Vector2.yAxis * WindowManager.Bar.Height)

        WindowViewport:SetPosition(Pivot2D.FromOffset(0, -WindowManager.Bar.Height))
    else
        WindowViewport:SetPosition(Pivot2D.FromOffset(0,0))
    end
    
    RootViewport:SetSize(Pivot2D.FromOffset(Size.X, Size.Y))
end

-- Set the viewport that will be automatically presented to the main screen each frame
function ViewportManager.SetViewports(InRoot,InWindow)
    RootViewport = InRoot
    WindowViewport = InWindow
end

function ViewportManager.GetRendered()
    return Rendered
end

function ViewportManager.GetRootViewport()
    return RootViewport
end

-- Create a canvas object
function ViewportManager.CreateViewport(Viewport, Size, UseMSAA)
    if Size.X < 10 or Size.Y < 10 then
        Size = Vector2.one * 2
    end

    local Canvas, Stencil = Runtime.Backend2D.NewCanvas(Size, true, UseMSAA)

    ViewportManager.Viewports[Viewport.UUID] = Viewport
    return Canvas, Stencil--, Mask
end

-- Render the contents of a 2d viewport
function ViewportManager.RenderViewport2D(Viewport)
    Profiler.Start("Render 2D Viewport ("..Viewport.Name..", "..#Viewport.DisplayList.." Objects)")
    Runtime.Backend2D.CanvasCall(Viewport:GetCanvas(), function()
        if Viewport:IsA("SurfaceViewport") then
            Runtime.Backend2D.DebugLabel(Viewport.MousePosition, "Position hit")
        end

        for _, Element in pairs(Viewport.DisplayList) do
            love.graphics.push()
            love.graphics.translate(Element.AbsolutePosition.X,Element.AbsolutePosition.Y)
            Rendered = Rendered + 1
            Profiler.Start("Draw "..Element.ClassName)
            Element:DrawStyle()
            Profiler.End()
            love.graphics.pop()
        end

        if Viewport.RenderClient then
            Viewport.RenderClient:Present()
        end
    end)
    Profiler.End()
end

-- Render the contents of a 3d viewport
function ViewportManager.RenderViewport3D(Viewport)
    --Profiler.Start("Render 3D Viewport ("..Viewport.Name..")")
    Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
        if Viewport.RenderContainer then
            Dream:prepare()

            --Dream:draw(Runtime.Backend3D.GetAdorns())
            Dream:addLight(Runtime.Backend3D.SunLight)
            Dream:addLight(Runtime.Backend3D.MoonLight)
            Viewport:Present()
            Runtime.Backend3D.PresentAdorns()
            Runtime.Backend3D.Debug:AddTask() -- TODO: Add to adorns

            for i,v in pairs(Viewport.RenderContainer.Lights) do
                Dream:addLight(v)
            end

            local Camera = Viewport:GetCamera()
            Dream:present(Camera and Camera.Drawable, Viewport.Canvases)
        else
            love.graphics.printf("Runtime: No render target/container specified",0,Viewport.AbsoluteSize.Y/2,Viewport.AbsoluteSize.X,"center")
        end
    end)
    --Profiler.End()
end

-- Render the canvas itself to the screen
function ViewportManager.RenderCanvas(Viewport)
    love.graphics.pushAll()

    if Viewport:IsA("Viewport2D") or Viewport:IsA("ViewportLite") then
        ViewportManager.RenderViewport2D(Viewport)
    else
        ViewportManager.RenderViewport3D(Viewport)
    end

    love.graphics.pop()

    Runtime.Backend2D.RenderCanvas(Viewport.ViewportCanvas)
end

function ViewportManager.GetMouseOffset()
    return -WindowViewport.Position.Offset
end

function ViewportManager.Render()
    Rendered = 0
    
    local WindowManager = Runtime.WindowManager

    if WindowManager.Bar.Enabled then
        WindowViewport:Draw()
    end

    local ViewportOffset = -WindowViewport.Position.Offset

    love.graphics.translate(ViewportOffset.X, ViewportOffset.Y)
    RootViewport:Draw()
end

return ViewportManager