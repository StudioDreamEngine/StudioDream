local ViewportManager = {}

local RootViewport ---@class ViewportContainer
local DecorationViewport ---@class Viewport2D
local light

function ViewportManager.Init()
    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDefaultReflection(false)
    Dream:setBloom(3)

    Dream:init() ---@diagnostic disable-line: missing-parameter

    LoveEvents.Resize:Connect(function(w,h)
        printVerbose("Resize detected, Updating Window decorations...")
        RootViewport:SetSize(Pivot2D.FromOffset(w,h))
    end)

    light = Dream:newLight("sun", Dream.vec3(2, 2, 2), Dream.vec3(1.0, 0.75, 0.5), 10.0)
    light:addNewShadow()

    ViewportManager.Viewports = {}
end

function ViewportManager.SetRootViewport(InRoot)
    RootViewport = InRoot
end

---@param RootDisplay Viewport2D
function ViewportManager.SetDecorationViewport(InDecoration, RootDisplay)
    DecorationViewport = InDecoration

    RootDisplay:SetRenderContainer(RootViewport)
end

function ViewportManager.CreateViewport(Viewport, Size)
    if Size.X < 10 or Size.Y < 10 then
        Size = Vector2.one * 2
    end

    local Canvas, Stencil, Mask = Runtime.Backend2D.NewCanvas(Size, true)

    ViewportManager.Viewports[Viewport.UUID] = Viewport
    return Canvas, Stencil, Mask
end

-- Render the contents of a 2d viewport
function ViewportManager.RenderViewport2D(Viewport)
    --Profiler.Start("Render 2D Viewport ("..Viewport.Name..", "..#Viewport.DisplayList.." Objects)")
    Runtime.Backend2D.CanvasCall(Viewport:GetCanvas(), function()
        love.graphics.clear()

        -- Dumbass hack because we need to make sure EVERY pixel has been drawn to before drawing more`
        Runtime.Backend2D.ShaderCall(function()
            love.graphics.rectangle("fill",0,0,Viewport.AbsoluteSize.X,Viewport.AbsoluteSize.Y)
        end, "Hack")

        for _, Element in pairs(Viewport.DisplayList) do
            love.graphics.push()
            love.graphics.translate(Element.AbsolutePosition.X,Element.AbsolutePosition.Y)
            Element:DrawStyle()
            love.graphics.pop()
        end
    end)
    --Profiler.End()
end

-- Render the contents of a 3d viewport
function ViewportManager.RenderViewport3D(Viewport)
    --Profiler.Start("Render 3D Viewport ("..Viewport.Name..")")
    if Viewport.RenderContainer then
        Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
            Dream:prepare()

            Dream:draw(Runtime.Backend3D.GetAdorns())
            Dream:draw(Runtime.Backend3D.Debug)
            Dream:addLight(light)
            Dream:draw(Viewport:GetWorld())
            for i,v in pairs(Viewport.RenderContainer.Lights) do
                Dream:addLight(v)
            end

            local Camera = Viewport:GetCamera()
            Dream:present(Camera and Camera.Drawable, Viewport.Canvases)
        end)
    end
    --Profiler.End()
end

-- Render the canvas itself to the screen
function ViewportManager.RenderCanvas(Viewport) 
    love.graphics.push("all")
    
    if Viewport:IsA("Viewport2D") then
        ViewportManager.RenderViewport2D(Viewport)
    else
        ViewportManager.RenderViewport3D(Viewport)
    end

    love.graphics.pop()

    Runtime.Backend2D.ShaderCall(function(Shader)
        Shader:send("mat_canvas", Viewport.MatCanvas)
        Runtime.Backend2D.RenderCanvas(Viewport.ViewportCanvas)
    end, "Final")
end

function ViewportManager.Update(dt)
    --TestCamera:update(dt,75)
    Dream:update(dt)
end

function ViewportManager.Render()
   -- DecorationViewport:Draw()
    RootViewport:Draw()
end

return ViewportManager