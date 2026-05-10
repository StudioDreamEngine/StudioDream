---@class MouseService
local MouseService = {}
local Backend2D = Runtime.Backend2D

MouseService.MouseMode = Enum.MouseMode.Free
MouseService.LockPosition = Vector3.zero

function MouseService.Init()
    
end

function MouseService.SetMouseMode(MouseMode)
    MouseService.LockPosition = Backend2D.GetMousePosition()
    MouseService.MouseMode = MouseMode
end

function MouseService.Update(dt)
    if MouseService.MouseMode == Enum.MouseMode.Locked then
        Backend2D.SetMousePosition(MouseService.LockPosition)
    end

    Backend2D.SetMouseVisible(MouseService.MouseMode == Enum.MouseMode.Free)
end

return MouseService