local Renderer = Runtime.Renderer
local Things = Runtime.Things

local Decorations = {}

local DecorationRoot, RootViewport, TitleBar

local MovingWindow = false
local MoveOrigin = Vector2.zero

local Delta = Vector2.zero

function Decorations.Init()
    DecorationRoot = Things.Create("Viewport2D") {
        Size = Pivot2D.FromOffset(1500,800),
        Name = "DecorationRoot",
        Parent = Things.Root,
        Serializable = false
    }

    LoveEvents.Resize:Connect(function(w,h)
        printVerbose("Resize detected, Updating Window decorations...")
        DecorationRoot:SetSize(Pivot2D.FromOffset(w,h))
    end)

    RootViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.new(1,-10,1,-35),
        Pivot = Vector2.new(0.5,0),
        Position = Pivot2D.new(0.5,0,0,30),
        Parent = DecorationRoot,
        Name = "Root"
    }

    Renderer.ViewportManager.SetDecorationViewport(DecorationRoot, RootViewport)
end

function Decorations.CreateTitleBar()
    TitleBar = Things.Create("Square") {
        Parent = DecorationRoot,
        Size = Pivot2D.new(1,0,0,30),
        BackgroundColor = Color.new(0,0,1),
        Text = ""
    }

    ---@class TextButton
    local Capture = Things.Create("TextButton") {
        BackgroundTransparency = 1,
        Text = "",
        Size = Pivot2D.new(1,-100,1,0),
        Parent = TitleBar
    }

    local MouseService = Runtime.Services.Service("MouseService") ---@class MouseService
    local InputService = Runtime.Services.Service("InputService") ---@class InputService

    ---@param MouseObject InputMouseObject
    InputService.MouseMoved:Connect(function(MouseObject)
        Delta = MouseObject.Delta
    end)

    Capture.Clicked:Connect(function() 
        MovingWindow = true
        MouseService.SetMouseMode(Enum.MouseMode.Locked) 
    end)

    Capture.Released:Connect(function() 
        MovingWindow = false 
        MouseService.SetMouseMode(Enum.MouseMode.Free) 
    end)
end

function Decorations.Update(dt)
    local MouseService = Runtime.Services.Service("MouseService") ---@class MouseService

    if MovingWindow then
        local Window = Runtime.WindowManager

        Window.SetPosition(Window.GetPosition() + (Delta * 2 * love.window.getDPIScale()))
    end

    love.mouse.setRelativeMode(MovingWindow)
    Delta = Vector2.zero
end

return Decorations