local Renderer = Runtime.Renderer
local Things = Runtime.Things

local WindowManager = {}
local Decoration, RootViewport

function WindowManager.Init()
    Decoration = Things.Create("Viewport2D") {
        Size = Pivot2D.FromOffset(1570,800),
        Name = "DecorationRoot",
        Parent = Things.Root,
        Serializable = false
    }

    RootViewport = Things.Create("Viewport2D") {
        Size = Pivot2D.new(-4,1,-30,1),
        Position = Pivot2D.FromOffset(2,30),
        Parent = Decoration,
        Name = "Root"
    }

    LoveEvents.Resize:Connect(function(w,h)
        printVerbose("Resize detected, Updating RootViewport...")
        Decoration:SetSize(Pivot2D.FromOffset(w,h))
    end)

    Renderer.ViewportManager.SetDecorationViewport(Decoration, RootViewport)
end

function WindowManager.SetWindowTheme(Primary, Text)
    
end

return WindowManager