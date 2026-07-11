local Things
local ViewportManager = {}

local RootViewport
local light, light2

function ViewportManager.Init()
    Things = Runtime.Things

    Dream:setSky(love.graphics.newCubeImage("Assets/sky.png"))
    Dream:setDefaultReflection(false)
    Dream:setBloom(3)

    Dream:init() ---@diagnostic disable-line: missing-parameter


    light = Dream:newLight("sun", Dream.vec3(2, 2, 2), Dream.vec3(1.0, 0.75, 0.5), 10.0)
    light:addNewShadow()

    ViewportManager.Viewports = {}

    LoveEvents.Resize:Connect(function(w,h)
        print("Resize detected, Updating RootViewport...")
        RootViewport:SetSize(Pivot2D.FromOffset(w,h))
    end)
end

function ViewportManager.SetRootViewport(InRoot)
    RootViewport = InRoot
end

function ViewportManager.CreateViewport(Viewport, Size)
    local Canvas = Runtime.Backend2D.NewCanvas(Size)

    ViewportManager.Viewports[Viewport.UUID] = Viewport
    return Canvas
end

local function RectStencil(Rect)
    love.graphics.rectangle("fill", 0,0,Rect.X, Rect.Y)
end

-- Render the contents of a 2d viewport
function ViewportManager.RenderViewport2D(Viewport)
    Profiler.Start("Render 2D Viewport")
    Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
        love.graphics.clear()

        for _, Element in pairs(Viewport.DisplayList) do
            love.graphics.push()
            love.graphics.translate(Element.AbsolutePosition.X,Element.AbsolutePosition.Y)

            --[[if Element.MaskSize then -- Rectangle mask, prob should move this into DrawStyle
                love.graphics.stencil(function()
                    RectStencil(Element.MaskSize)
                end, "replace", 1)

                love.graphics.setStencilTest("greater", 0)
            end]]

            Element:DrawStyle()

            --love.graphics.setStencilTest()
            love.graphics.pop()
        end

        --love.graphics.circle("fill", Viewport.MousePosition.X, Viewport.MousePosition.Y, 10)
    end)
    Profiler.End()
end

-- Render the contents of a 3d viewport
function ViewportManager.RenderViewport3D(Viewport)
    Profiler.Start("Render 3D Viewport")
    if Viewport.RenderContainer then
        Runtime.Backend2D.CanvasCall(Viewport.ViewportCanvas, function()
            Dream:resize(Viewport.AbsoluteSize.X, Viewport.AbsoluteSize.Y)
            Dream:prepare()
            Dream:draw(Runtime.Backend3D.GetAdorns())
            Dream:addLight(light)
            Dream:draw(Viewport:GetWorld())
            Dream:present()
        end)
    end
    Profiler.End()
end

-- Render the canvas itself to the screen
function ViewportManager.RenderCanvas(Viewport) 
    if Viewport:IsA("Viewport2D") then
        ViewportManager.RenderViewport2D(Viewport)
    else
        ViewportManager.RenderViewport3D(Viewport)
    end

    Runtime.Backend2D.RenderCanvas(Viewport.ViewportCanvas) 
end

function ViewportManager.Update(dt)
    --TestCamera:update(dt,75)
    Dream:update(dt)
end

function ViewportManager.Render()
    ViewportManager.RenderCanvas(RootViewport)
end

return ViewportManager