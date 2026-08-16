-- Handles the layout of windows themself
local Things = Runtime.Things
local StudioLayout = {}

local Theme = Studio.CurrentTheme

StudioLayout.Handles = {}

function StudioLayout.CreateWindowContainer(Transform, HaveName)
    local Windows = {}
    
    Windows.FullContainer = Studio.Components.CreateStyle("Square",{
        Size = Transform.Size,
        Position = Transform.Position,
        Pivot = Transform.Pivot,
        BackgroundColor = "Outline",
        Name = "WindowContainer",
        Layer = Transform.Layer or 1,
        Parent = Transform.TopLevel and Things.Root.RootViewport or StudioLayout.Windows,
        CornerRadius = Transform.CornerRadius or 5,
       -- OutlineSize = 2,
        OutlineColor = "Outline"
    })
    
    Windows.Container = Studio.Components.CreateStyle("Square",{
        Size = (not HaveName) and Pivot2D.FromScale(0.99,0.99) or Pivot2D.FromScale(0.99,0.93),
        Position = (not HaveName) and Pivot2D.FromScale(0.5,0.5) or Pivot2D.FromScale(0.5,0.06),
        Pivot = (not HaveName) and Vector2.new(0.5,0.5) or Vector2.new(0.5,0),
        BackgroundColor = "Primary",
        Name = "BackWindow",
        Layer = 2,
        Parent = Windows.FullContainer,
        CornerRadius = Transform.CornerRadius or 2.5,
        Serializable = false
    })

    if Transform.Shadows then
        Windows.Shadow = Studio.Components.CreateDropshadow(Windows.FullContainer)
    end

    -- GUARD CLAUSES MIKL
    --print(HaveName)
    if (not HaveName) then return Windows end
    --print("BLEH")
    Windows.ContainerNamer = Studio.Components.CreateStyle("Square", {
        Size = Pivot2D.FromScale(0.99,0.1),
        Position = Pivot2D.FromScale(0.5,0.01),
        Pivot = Vector2.new(0.5,0),
        Parent = Windows.FullContainer,
        Layer = 1,
        BackgroundTransparency = 0,
        Text = HaveName,
        Name = "WindowText",
        Alignment = Vector2.new(0.5,0.5),
        BackgroundColor = "Outline",
        CornerRadius = 4,
    })
    Windows.Namer = Studio.Components.CreateStyle("Text", {
        Size = Pivot2D.FromScale(0.99,0.5),
        Position = Pivot2D.FromScale(0.5,0),
        Pivot = Vector2.new(0.5,0),
        Parent = Windows.ContainerNamer,
        BackgroundTransparency = 1,
        Text = HaveName,
        ForegroundColor = "Text",
        Name = "WindowText",
        Alignment = Vector2.new(0.5,0.5),
        Font = "FontTalic",
        CornerRadius = 4,
    })

    if Transform.Closable then
        Studio.Components.CreateStyle("ImageButton", {
            Size = Pivot2D.FromScale(1.5,0.5),
            SquareAxis = Enum.SquareAxis.Y,
            Parent = Windows.ContainerNamer,
            CornerRadius = 5,
            Pivot = Vector2.new(0,0),
            Position = Pivot2D.FromScale(0,0),
            BackgroundTransparency = 0,
            Layer = 2,
            Clicked = function()
                Windows.FullContainer:SetVisible(false)
            end,
            Resource = "Internal/Studio/Close.png",
            ScaleType = Enum.ScaleType.LockAspect,
            ForegroundColor = "Text",
            BackgroundColor = "Outline"
        })
    end

    return Windows
end

function StudioLayout.GetMouseContext(Context)
    -- TODO: Choose pivot point of object based on where it is on the screen, pivot point is simply added to the final position, it doesnt change the object pivot (maybe)
    return Pivot2D.FromOffset(Things.GetRootViewport().MousePosition)
end

function StudioLayout.CreateWindowHandler(WindowType, WindowContainer)
    printVerbose("Creating new WindowHandler:",WindowType)
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
    WindowContainer.FullContainer.Name = "Windows."..WindowType

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
    StudioLayout.TopBar = Studio.Components.CreateStyle("Square",{
        Parent = Things.Root.RootViewport,
        Name = "TopBar",
        Size = Pivot2D.FromScale(1,0.15),
        BackgroundColor = "Outline"
    })

    local MenuBar = Studio.Components.CreateStyle("Square",{
        Parent = StudioLayout.TopBar,
        Name = "MenuBar",
        Position = Pivot2D.FromScale(0,0.0),
        Size = Pivot2D.FromScale(1,0.2),
        BackgroundTransparency = 1
    })

    local TopbarInner = Studio.Components.CreateStyle("Square",{
        Parent = StudioLayout.TopBar,
        Name = "ToolBar",
        Position = Pivot2D.FromScale(0,0.2),
        Size = Pivot2D.FromScale(1,0.8),
        BackgroundColor = "Primary",
        BackgroundTransparency = 0
    })

    StudioLayout.CreateWindowHandler("TopBar", { Container = TopbarInner })
    StudioLayout.CreateWindowHandler("MenuBar", { Container = MenuBar })
end

function StudioLayout.CreateLayout()
    printVerbose("Creating studio layout")
    StudioLayout.CreateTopbar()

    StudioLayout.Windows = Studio.Components.CreateStyle("Square",{
        Name = "WindowContainer",
        Parent = Things.Root.RootViewport,
        Pivot = Vector2.new(0,1),
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(1,0.85),
        Layer = 10,
        BackgroundTransparency = 1
    })

    StudioLayout.CreateWindow("Viewport", {
        Size = Pivot2D.FromScale(0.8,.8),
        CornerRadius = 0,
    })

    StudioLayout.CreateWindow("InsertObject", {
        Size = Pivot2D.FromScale(0.25,.25),
        Position = Pivot2D.FromScale(.5,1),
        Pivot = Vector2.new(0,0),
        Layer = 100,
        TopLevel = true
    })

    StudioLayout.CreateWindow("Inspector", {
        Name = "Inspector",
        Size = Pivot2D.FromScale(0.2,.5),
        Position = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,1),
        Layer = 3,
        CornerRadius = 0,
    })

    StudioLayout.CreateWindow("Explorer", {
        Name = "Tree",
        Size = Pivot2D.FromScale(0.2,.5),
        Position = Pivot2D.FromScale(1,0),
        Pivot = Vector2.new(1,0),
        CornerRadius = 0,
    })

    StudioLayout.CreateWindow("Notification", {
        Size = Pivot2D.FromScale(0.2,1),
        Pivot = Vector2.new(0,0.5),
        Position = Pivot2D.FromScale(0,0.5),
        Layer = 999,
        TopLevel = true
    })

    StudioLayout.CreateWindow("Output", {
        Position = Pivot2D.FromScale(0.15,1),
        Size = Pivot2D.FromScale(0.65,.2),
        Pivot = Vector2.new(0,1),
        CornerRadius = 0,
    })

    StudioLayout.CreateWindow("PConfig", {
        Size = Pivot2D.FromScale(0.5,0.6),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Layer = 500,
        --TopLevel = true,
        Shadows = true,
        Name = "Project Configuration",
    })

    StudioLayout.CreateWindow("StudioConfig", {
        Size = Pivot2D.FromScale(0.5,0.6),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Layer = 500,
        --TopLevel = true,
        Closable = true,
        Shadows = true,
        Name = "Editor Configuration",
    })

    StudioLayout.CreateWindow("Toolbar", {
        Size = Pivot2D.FromScale(0.025,0.7),
        Pivot = Vector2.new(0,0.5),
        Position = Pivot2D.FromScale(0.005,0.4),
        Layer = 300,
        CornerRadius = 100,
    })

    if (not FLAGS.SecondRun) then
        Studio.Components.ShowFade()
        StudioLayout.CreateWindow("Start", {
            Size = Pivot2D.FromScale(0.5,0.6),
            Pivot = Vector2.new(0.5,0.5),
            Position = Pivot2D.FromScale(0.5,0.5),
            Layer = 300,
            TopLevel = true,
            Shadows = true,
        })
    end

    StudioLayout.CreateWindow("Macros", {
        Position = Pivot2D.FromScale(0,1),
        Size = Pivot2D.FromScale(0.15,0.2),
        Pivot = Vector2.new(0,1),
        Name = "Macros"
    })

    --[[StudioLayout.CreateWindow("Trollo",{
        Size = Pivot2D.FromScale(0.15,0.6),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Layer = 300,
        TopLevel = true,
        Shadows = true,
    })]]

    StudioLayout.ToggleWindow(StudioLayout.GetHandle("InsertObject"), false)
    StudioLayout.ToggleWindow(StudioLayout.GetHandle("PConfig"), false)
    StudioLayout.ToggleWindow(StudioLayout.GetHandle("StudioConfig"), false)
end

function StudioLayout.Update(dt)
    for _, Handler in pairs(StudioLayout.Handles) do
        if Handler.Update then
            Handler.Update(dt)
        end
    end
end

return StudioLayout