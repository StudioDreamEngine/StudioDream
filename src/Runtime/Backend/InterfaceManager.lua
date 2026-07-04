---@diagnostic disable: param-type-mismatch, need-check-nil
-- Handles general background tasks related to the currently rendering viewports
local InterfaceManager = {}
InterfaceManager.Buttons = {}

function InterfaceManager.Init()
    InterfaceManager.OnMouseMove = Signal:New("MouseMove") 
    InterfaceManager.OnClick = Signal:New("MouseClick") 
    InterfaceManager.OnRightClick = Signal:New("MouseClick2")

    -- Keep it always enabled for now
    -- in the future (if we wanna) we can rewrite the hover system to make this work, as doing it the way we were wouldnt work
    love.keyboard.setTextInput(true)

    LoveEvents.MousePressed:Connect(function(x,y,button)
        if button == 1 then
            InterfaceManager.OnClick.Invoke()
        elseif button == 2 then
            InterfaceManager.OnRightClick.Invoke()
        end
    end)
end

function InterfaceManager.RegisterButton(Button)
    table.insert(InterfaceManager.Buttons, Button)
end

function InterfaceManager.UnregisterButton(Button)
    table.removeValue(InterfaceManager.Buttons, Button)
end

function InterfaceManager.Update(dt)
    local Backend2D = Runtime.Backend2D
    local ViewportManager = Runtime.Renderer.ViewportManager

    for _, Viewport in pairs(ViewportManager.Viewports) do
        Viewport.MousePosition = Backend2D.GetMousePosition() - Viewport.AbsolutePosition
    end

    Profiler.Start("InterfaceManager - Process Hovering")
    local CurrentlyHovering = {}

    for _, Button in pairs(InterfaceManager.Buttons) do
        local DisplayUI = Button:GetDisplayUI()

        if DisplayUI then -- WHY DOESNT LUA HAVE THE CONTINUE KEYWORD AHSIUEYUWRFHJLUEJDKHF;p
            Button.Hovering = false
        
            if Button:IsVisible() and Utils.IntersectPoint2D(Button:GetChildRect(), DisplayUI.MousePosition) and (not Button:IsAlwaysOnTop()) then
                table.insert(CurrentlyHovering, Button)
            end
        end
    end

    if #CurrentlyHovering > 0 then
        table.sort(CurrentlyHovering, function (a, b) return a.AbsoluteLayer > b.AbsoluteLayer end)
        CurrentlyHovering[1].Hovering = true
    end
    Profiler.End()
end

return InterfaceManager