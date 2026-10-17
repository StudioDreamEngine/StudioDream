---@diagnostic disable: param-type-mismatch, need-check-nil
-- Handles general background tasks related to the currently rendering viewports, alongside management of hovering
local InterfaceManager = {}
InterfaceManager.Buttons = {}

InterfaceManager.Clicking = false
InterfaceManager.Hovering = false
InterfaceManager.ClickSurface = nil

function InterfaceManager.Init()
    InterfaceManager.OnMouseMove = Signal:New("MouseMove") 
    InterfaceManager.OnClick = Signal:New("MouseClick", true) 
    InterfaceManager.OnRelease = Signal:New("MouseClick") 
    InterfaceManager.OnRightClick = Signal:New("MouseClick2")
    InterfaceManager.OnClickPress = Signal:New("MouseClick4")
    InterfaceManager.OnClickGeneral = Signal:New("MouseClick3")

    -- Keep it always enabled for now
    -- in the future (if we wanna) we can rewrite the hover system to make this work, as doing it the way we were wouldnt work
    love.keyboard.setTextInput(true)

    LoveEvents.MousePressed:Connect(function(x,y,button)
        if button == Enum.MouseButton.RightClick then
            InterfaceManager.OnRightClick.Invoke(Vector2.new(x,y))
        elseif button == Enum.MouseButton.LeftClick then
            InterfaceManager.OnClickPress.Invoke()
        end

        InterfaceManager.OnClickGeneral.Invoke(Vector2.new(x,y))
    end)

    Runtime.SelectionPriority.GuiClick:Connect(function()
        InterfaceManager.OnClick.Invoke()
        InterfaceManager.Clicking = true
    end)

    LoveEvents.MouseReleased:Connect(function(_,_,button)
        if button == Enum.MouseButton.LeftClick then -- TODO: Use listener
            InterfaceManager.OnRelease.Invoke()
            InterfaceManager.Clicking = false
        end
    end)
end

-- Register a button to be handled by the hovering system
function InterfaceManager.RegisterButton(Button)
    table.insert(InterfaceManager.Buttons, Button)
end

-- Remove a button from the InterfaceManager.
function InterfaceManager.UnregisterButton(Button)
    table.removeValue(InterfaceManager.Buttons, Button)
end

local CurrentlyHovering = {}
local Huge = Vector2.one * 100000

-- Handles the position of the mouse for a Viewport that is a part of a 3d space
---@param Viewport SurfaceViewport
local function HandleSurface(Viewport)
    Viewport.MousePosition = Huge

    local Display = Viewport.DisplayUI ---@class Viewport3D
    if (not Display) or (not Display:IsA("Viewport3D")) then return end
    if (not Runtime.SelectionPriority.Use3DSelection) then return end

    if Display.AdornRay then
        local UV = Display.AdornRay.UV
        local HoveringViewport = Display.AdornRay.Thing.UUID

        if HoveringViewport == Viewport.UUID then
            InterfaceManager.ClickSurface = Viewport

            Viewport.MousePosition = UV * Viewport.AbsoluteSize
        end
    end
end

function InterfaceManager.DebugDraw()
    local Text = ""

    for _, Hovering in pairs(CurrentlyHovering) do
        Text = Text..tostring(Hovering)..": "..Hovering.AbsoluteLayer.."\n"
    end

    Runtime.Backend2D.DebugPrint(Vector2.yAxis, Text)
end

function InterfaceManager.Update(dt)
    local Backend2D = Runtime.Backend2D
    local ViewportManager = Runtime.Renderer.ViewportManager

    InterfaceManager.ClickSurface = nil

    -- Go through all viewports and update their mouse-positions for all objects
    ---@param Viewport Viewport
    for _, Viewport in pairs(ViewportManager.Viewports) do
        --print(Viewport.ViewportPosition)
        if Viewport:IsA("SurfaceViewport") then -- Surface viewports are treated differently then regular ones
            HandleSurface(Viewport)
        else
            Viewport.MousePosition = (Backend2D.GetMousePosition() - Viewport.ViewportPosition) --- Viewport.AbsolutePivot
        end

        Viewport.MousePosition = (Viewport.MousePosition / Viewport.Scale)

        if Viewport.RenderContainer then
            Viewport.RenderContainer.MousePosition = Viewport.MousePosition
        end
    end

    Profiler.Start("InterfaceManager - Process Hovering")

    table.clear(CurrentlyHovering)
    InterfaceManager.Hovering = false

    -- Hovering pass 1: Go through all buttons and determine which are being hovered
    for _, ButtonID in pairs(InterfaceManager.Buttons) do
        local Button = Runtime.Things.Get(ButtonID)
        local DisplayUI

        if Button then DisplayUI = Button.DisplayUI end
        
        -- MousePosition check is a hack here for now
        if DisplayUI and DisplayUI.MousePosition then -- WHY DOESNT LUA HAVE THE CONTINUE KEYWORD AHSIUEYUWRFHJLUEJDKHF;p
            Button.Hovering = false

            -- DisplayHovering makes sure that an object is only considered hovering in a ScrollContainer if the ScrollContainer itself is also being hovered over.
            local DisplayHovering = true

            if DisplayUI:IsA("ScrollContainer") then 
                DisplayHovering = DisplayUI.Hovering
            end

            --[[if (not CurrentlyHovering[DisplayUI.UUID]) then
                CurrentlyHovering[DisplayUI.UUID] = {}
            end]]
        
            if Button.TruelyVisible and Utils.IntersectPoint2D(Button:GetProperty("ChildRect"), DisplayUI.MousePosition) and DisplayHovering and (not Button:IsAlwaysOnTop()) then
                table.insert(CurrentlyHovering, Button)
            end
        end
    end

    --[[for i,v in pairs(CurrentlyHovering) do
        if v.Hovering == false then
            print("coil")
        end
    end]]

    Runtime.Cursor.ChangeCursorInternal((#CurrentlyHovering > 0) and "Hovering" or "Main", true)

    -- Hovering pass 2: Sort and determine the currently hovering objects
    if #CurrentlyHovering > 0 then
        table.sort(CurrentlyHovering, function(a, b)
            return (a.AbsoluteLayer > b.AbsoluteLayer)
        end)
        
        -- Frontmost hovering object is set as the interfacemanagers hovering object
        InterfaceManager.Hovering = CurrentlyHovering[1]

        -- Handle updating hovering for all objects
        for _, Hovering in pairs(CurrentlyHovering) do
            Hovering.Hovering = true
            if Hovering.SinkHovering then
                break
            end
        end
    end
    
    Profiler.End()
end

return InterfaceManager