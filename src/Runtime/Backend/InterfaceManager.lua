-- Handles general background tasks related to the currently rendering viewports
local InterfaceManager = {}

function InterfaceManager.Update(dt)
    local Backend2D = Runtime.Backend2D
    local ViewportManager = Runtime.Renderer.ViewportManager

    for _, Viewport in pairs(ViewportManager.Viewports) do
        Viewport.MousePosition = Backend2D.GetMousePosition() - Viewport:GetDisplayPosition()
    end
end

return InterfaceManager