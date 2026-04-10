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

return InterfaceManager