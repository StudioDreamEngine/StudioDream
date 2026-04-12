-- Handles general background tasks related to the currently rendering viewports
local InterfaceManager = {}

InterfaceManager.Clicking = false

function InterfaceManager.Init()
   InterfaceManager.OnMouseMove = Signal:New("MouseMove") 
   InterfaceManager.OnClick = Signal:New("MouseClick") 
end

function InterfaceManager.UpdateInput()
    local Backend2D = Runtime.Backend2D
    local CurrentlyClicking = Backend2D.GetMouseDown()

    if CurrentlyClicking and (not InterfaceManager.Clicking) then
        InterfaceManager.OnClick.Invoke()
    end

    InterfaceManager.Clicking = CurrentlyClicking
end

function InterfaceManager.Update(dt)
    local Backend2D = Runtime.Backend2D
    local ViewportManager = Runtime.Renderer.ViewportManager

    for _, Viewport in pairs(ViewportManager.Viewports) do
        Viewport.MousePosition = Backend2D.GetMousePosition() - Viewport:GetDisplayPosition()
    end

    InterfaceManager.UpdateInput()
end

local NodeColor = Color.new(0.314, 0.294, 0.502)
local WindowColor = Color.new(0.106, 0.09, 0.188)
local BackWindowColor = Color.new(0.149, 0.129, 0.333)

function InterfaceManager.CreateWindow(Size,Position,View)
    local Windows = {}
    Windows.Container = Runtime.Things.Create "SquarePrimative" { 
      Size = Size,
       Explorer = {
        Visible = false,
       },
       Position = Position,
       Pivot = Vector2.new(0,0.5),
       BackgroundColor = WindowColor,
       Name = "Properties",
       Layer = 1,
       Parent = View
    }
    
    Windows.BackWindow = Runtime.Things.Create "SquarePrimative" {
       Size = Pivot2D.FromScale(0.9,0.9),
       Position = Pivot2D.FromScale(0.5,0.5),
       Pivot = Vector2.new(0.5,0.5),
       Explorer = {
        Visible = false,
       },
       BackgroundColor = BackWindowColor,
       Name = "BackWindow",
       Layer = 2,
       Parent = Windows.Container
    }

    return Windows
end

return InterfaceManager