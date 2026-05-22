-- Handles the layout of windows themself
local Things = Runtime.Things
local StudioLayout = {}

local Theme = Studio.Theme

StudioLayout.Handles = {}

function StudioLayout.CreateWindowContainer(Transform, Parent)
    local Windows = {}
    
    Windows.Container = Runtime.Things.Create("Square") { 
        Size = Transform.Size,
        Position = Transform.Position,
        Pivot = Transform.Pivot,
        BackgroundColor = Theme.Secondary,
        Name = "Properties",
        Layer = Transform.Layer or 1,
        Parent = Parent or StudioLayout.Windows,
        CornerRadius = 5,
        OutlineSize = 5,
        OutlineColor = Theme.Outline
    }
    
    Windows.BackWindow = Runtime.Things.Create("Square") {
        Size = Pivot2D.FromScale(0.95,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Theme.Primary,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.Container,
        CornerRadius = 2.5,
    }

    return Windows.BackWindow
end

function StudioLayout.CreateWindowHandler(WindowType, WindowContainer)
    local Window = require("Studio.UI."..WindowType)
    Window.Container = WindowContainer -- TODO: Remove from Init
    Window.Init(WindowContainer)

    if StudioLayout.Handles[WindowType] then
        error("Cannot have more than one of the same Window Handler Type!")
    end

    StudioLayout.Handles[WindowType] = Window
end

function StudioLayout.CreateWindow(WindowType, Transform, Parent)
    local WindowContainer = StudioLayout.CreateWindowContainer(Transform, Parent)

    StudioLayout.CreateWindowHandler("Windows."..WindowType, WindowContainer)
end

-- Remove any window handle that starts with "Window.", as other handles are used for the topbar, which is immutable
function StudioLayout.RemoveWindow(WindowType)
    local Handle = StudioLayout.GetHandle(WindowType, "Destroy")

    Handle.Container:Destroy()
end

-- Calls a function within a different window handle
function StudioLayout.GetHandle(WindowType, Function, ...)
    local HasHandle = StudioLayout.Handles["Windows."..WindowType] -- For now, we can only get handles of windows, not the topbar

    if HasHandle then
        HasHandle[Function](...)

        return HasHandle
    end
end

--[[
    How should we even handle layouts
    idk how this entire flow system should work at all
]]

function StudioLayout.CreateTopbar()
    StudioLayout.TopBar = Things.Create("Square") {
        Parent = Things.Root.RootViewport,
        Size = Pivot2D.FromScale(1,0.15),
        BackgroundColor = Theme.Primary
    }

    local TopbarInner = Things.Create("Square") {
        Parent = StudioLayout.TopBar,
        Position = Pivot2D.FromScale(0,0.3),
        Size = Pivot2D.FromScale(1,0.7),
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindowHandler("TopBar", TopbarInner)
end

function StudioLayout.CreateLayout()
    StudioLayout.CreateTopbar()

    StudioLayout.Windows = Things.Create("Square") {
        Parent = Things.Root.RootViewport,
        Pivot = Vector2.new(0,1),
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(1,0.85),
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindow("Viewport", {
        Size = Pivot2D.FromScale(0.75,.9),
    })

    StudioLayout.CreateWindow("Properties", {
        Size = Pivot2D.FromScale(0.25,.5),
        Position = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,1),
        Layer = 3,
    })

    StudioLayout.CreateWindow("Explorer", {
        Size = Pivot2D.FromScale(0.25,.5),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0)
    })
end

function StudioLayout.Update(dt)
    for _, Handler in pairs(StudioLayout.Handles) do
        if Handler.Update then
            Handler.Update(dt)
        end
    end
end

return StudioLayout