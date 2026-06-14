-- Handles the layout of windows themself
local Things = Runtime.Things
local StudioLayout = {}

local Theme = Studio.Theme.GetCurrentTheme()

StudioLayout.Handles = {}

function StudioLayout.CreateWindowContainer(Transform, HaveName)
    local Windows = {}
    
    Windows.FullContainer = Runtime.Things.Create("Square") { 
        Size = Transform.Size,
        Position = Transform.Position,
        Pivot = Transform.Pivot,
        BackgroundColor = Theme.Secondary,
        Name = "WindowContainer",
        Layer = Transform.Layer or 1,
        Parent = Transform.TopLevel and Things.Root.RootViewport or StudioLayout.Windows,
        CornerRadius = 5,
        OutlineSize = 5,
        OutlineColor = Theme.Outline
    }
    
    Windows.Container = Runtime.Things.Create("Square") {
        Size = (not HaveName) and Pivot2D.FromScale(0.99,0.99) or Pivot2D.FromScale(0.95,0.9),
        Position = (not HaveName) and Pivot2D.FromScale(0.5,0.5) or Pivot2D.FromScale(0.5,0.51),
        Pivot = Vector2.new(0.5,0.5),
        BackgroundColor = Theme.Primary,
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.FullContainer,
        CornerRadius = 2.5,
        Serializable = false
    }

    -- GUARD CLAUSES MIKL
    if not HaveName then return Windows end
    Windows.Namer = Runtime.Things.Create("Text") {
        Size = Pivot2D.FromScale(0,0),
        Position = Pivot2D.FromScale(0,0),
        Pivot = Vector2.new(0,0),
        Parent = Windows.Container,
        Layer = Windows.Container.Layer+5,
        BackgroundTransparency = 1,
        Text = HaveName,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        Name = "WindowText",
        Alignment = Vector2.new(0.5,0.5),
        Font = Studio.Theme.GetCurrentTheme().FontNormal
    }

    return Windows
end

function StudioLayout.GetMouseContext(Context)
    -- TODO: Choose pivot point of object based on where it is on the screen, pivot point is simply added to the final position, it doesnt change the object pivot (maybe)
    return Pivot2D.FromOffset(Things.GetRootViewport().MousePosition)
end

function StudioLayout.CreateWindowHandler(WindowType, WindowContainer)
    local Window = require("Studio.UI."..WindowType)
    Window.FullContainer = WindowContainer.FullContainer
    Window.Container = WindowContainer.Container
    Window.Init()

    if StudioLayout.Handles[WindowType] then
        error("Cannot have more than one of the same Window Handler Type!")
    end

    StudioLayout.Handles[WindowType] = Window
end

function StudioLayout.CreateWindow(WindowType, Transform)
    local WindowContainer = StudioLayout.CreateWindowContainer(Transform, Transform.Name)

    StudioLayout.CreateWindowHandler("Windows."..WindowType, WindowContainer)
end

-- Robuxxy worst nightmare
function StudioLayout.ToggleWindow(Window, Toggle)
    Window.FullContainer:SetVisible(Toggle)
end

---@param To Pivot2D
function StudioLayout.MoveWindow(Window, To)
    Window.FullContainer:SetPosition(To)
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
        Name = "TopBar",
        Size = Pivot2D.FromScale(1,0.15),
        BackgroundColor = Theme.Primary
    }

    local MenuBar = Things.Create("Square") {
        Parent = StudioLayout.TopBar,
        Name = "MenuBar",
        Position = Pivot2D.FromScale(0,0.0),
        Size = Pivot2D.FromScale(1,0.3),
        BackgroundTransparency = 1
    }

    local TopbarInner = Things.Create("Square") {
        Parent = StudioLayout.TopBar,
        Name = "ToolBar",
        Position = Pivot2D.FromScale(0,0.3),
        Size = Pivot2D.FromScale(1,0.7),
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindowHandler("TopBar", { Container = TopbarInner })
    StudioLayout.CreateWindowHandler("MenuBar", { Container = MenuBar })
end

function StudioLayout.CreateLayout()
    StudioLayout.CreateTopbar()

    StudioLayout.Windows = Things.Create("Square") {
        Name = "WindowContainer",
        Parent = Things.Root.RootViewport,
        Pivot = Vector2.new(0,1),
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(1,0.85),
        Layer = 10,
        BackgroundTransparency = 1
    }

    StudioLayout.CreateWindow("Viewport", {
        Size = Pivot2D.FromScale(0.75,.9),
    })

    StudioLayout.CreateWindow("InsertObject", {
        Size = Pivot2D.FromScale(0.25,.25),
        Position = Pivot2D.FromScale(.5,1),
        Pivot = Vector2.new(0,0),
        Layer = 100,
        TopLevel = true
    })

    StudioLayout.CreateWindow("Properties", {
        Size = Pivot2D.FromScale(0.25,.5),
        Position = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,1),
        Layer = 3,
    })

    StudioLayout.CreateWindow("Explorer", {
        Name = "Explorer",
        Size = Pivot2D.FromScale(0.25,.5),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0)
    })

    StudioLayout.CreateWindow("Notification", {
        Size = Pivot2D.FromScale(0.2,1),
        Pivot = Vector2.new(0,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Layer = 100,
        TopLevel = true
    })

    StudioLayout.ToggleWindow(StudioLayout.GetHandle("InsertObject"), false)
end

function StudioLayout.Update(dt)
    for _, Handler in pairs(StudioLayout.Handles) do
        if Handler.Update then
            Handler.Update(dt)
        end
    end
end

return StudioLayout