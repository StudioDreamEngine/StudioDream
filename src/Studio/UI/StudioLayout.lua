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
        Size = Pivot2D.FromScale(0.95,0.9),
        Position = Pivot2D.FromScale(0.5,0.51),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Theme.Primary,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.Container,
        CornerRadius = 2.5,
    }

    Windows.Namer = Runtime.Things.Create("Text") {
        Size = Pivot2D.FromScale(1,0.05),
        Position = Pivot2D.FromScale(0.5,0.01),
        Pivot = Vector2.new(0.5,0),
        Parent = Windows.Container,
        Layer = Windows.Container.Layer+5,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text,
        Align = Vector2.new(0.5,0.5)
    }
    Windows.Namer:SetFont("Assets/Fonts/Roboto/Roboto-Medium.ttf")

    return Windows
end

function StudioLayout.CreateWindowHandler(WindowType, WindowContainer)
    local Window = require("Studio.UI."..WindowType)
    Window.Container = WindowContainer
    Window.Init()

    if StudioLayout.Handles[WindowType] then
        error("Cannot have more than one of the same Window Handler Type!")
    end

    StudioLayout.Handles[WindowType] = Window
end

function StudioLayout.CreateWindow(WindowType, Transform, Parent)
    local WindowContainer = StudioLayout.CreateWindowContainer(Transform, Parent)
    WindowContainer.Namer.Text = WindowType
    StudioLayout.CreateWindowHandler("Windows."..WindowType, WindowContainer.BackWindow)
end

-- Robuxxy worst nightmare
function StudioLayout.ToggleWindow(Window, Toggle)
    StudioLayout.GetHandle(Window).Container.Visible = Toggle
end

---@param To Pivot2D
function StudioLayout.MoveWindow(Window, To)
    StudioLayout.GetHandle(Window).Container:SetPosition(To)
end

-- Remove any window handle that starts with "Window.", as other handles are used for the topbar, which is immutable
function StudioLayout.RemoveWindow(WindowType)
    local Handle = StudioLayout.CallHandle(WindowType, "Destroy")

    Handle.Container:Destroy()
end

function StudioLayout.GetHandle(WindowType)
    local HasHandle = StudioLayout.Handles["Windows."..WindowType] -- For now, we can only get handles of windows, not the topbar

    if HasHandle then return HasHandle end
end

function StudioLayout.CallHandle(WindowType, Function, ...)
    local Handle = StudioLayout.GetHandle(WindowType)

    if Handle then
        Handle[Function](...)

        return Handle
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

    local MenuBar = Things.Create("Square") {
        Parent = StudioLayout.TopBar,
        Position = Pivot2D.FromScale(0,0.0),
        Size = Pivot2D.FromScale(1,0.3),
        BackgroundTransparency = 1
    }

    local TopbarInner = Things.Create("Square") {
        Parent = StudioLayout.TopBar,
        Position = Pivot2D.FromScale(0,0.3),
        Size = Pivot2D.FromScale(1,0.7),
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindowHandler("TopBar", TopbarInner)
    StudioLayout.CreateWindowHandler("MenuBar", MenuBar)
end

function StudioLayout.CreateLayout()
    StudioLayout.CreateTopbar()

    StudioLayout.Windows = Things.Create("Square") {
        Name = "WindowContainer",
        Parent = Things.Root.RootViewport,
        Pivot = Vector2.new(0,1),
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(1,0.85),
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindow("Viewport", {
        Size = Pivot2D.FromScale(0.75,.9),
    })

    --[[StudioLayout.CreateWindow("InsertObject", {
        Size = Pivot2D.FromScale(0.25,.5),
        Position = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,1),
        Layer = 3,
        Visible = false
    })]]

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