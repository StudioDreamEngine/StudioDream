---@class MouseService
local MouseService = {}
local Backend2D = Runtime.Backend2D

MouseService.MouseMode = Enum.MouseMode.Free
MouseService.LockPosition = Vector3.zero
MouseService.CurrentCursor = '' -- gotta make sure this is read-only for Scripts >:3
-- honestly, we really need to add ScriptCapability shit anyway; but that'll be really annoyingggg :3

function MouseService.Init()
    
end

local CurrentCursorPack = "Assets/Cursors/"

function MouseService.ChangeCursor(ChangeTo)
    love.mouse.setCursor(love.mouse.newCursor(CurrentCursorPack..ChangeTo..".png", 0,0))
    MouseService.CurrentCursor = ChangeTo
    printVerbose("Cursor Changed to: "..ChangeTo)
end

function MouseService.GetPosition()
    return Backend2D.GetMousePosition()
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