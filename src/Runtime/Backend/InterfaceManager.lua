-- Handles general background tasks related to the currently rendering viewports
local InterfaceManager = {}

function InterfaceManager.Init()
    InterfaceManager.OnMouseMove = Signal:New("MouseMove") 
    InterfaceManager.OnClick = Signal:New("MouseClick") 
    InterfaceManager.OnRightClick = Signal:New("MouseClick2")

    LoveEvents.MousePressed:Connect(function(x,y,button)
        if button == 1 then
            InterfaceManager.OnClick.Invoke()
        elseif button == 2 then
            InterfaceManager.OnRightClick.Invoke()
        end
    end)
end

function InterfaceManager.Update(dt)
    local Backend2D = Runtime.Backend2D
    local ViewportManager = Runtime.Renderer.ViewportManager

    for _, Viewport in pairs(ViewportManager.Viewports) do
        Viewport.MousePosition = Backend2D.GetMousePosition() - Viewport:GetDisplayPosition()
    end
end

return InterfaceManager