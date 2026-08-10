---@class MouseService
local MouseService = {}
local Backend2D = Runtime.Backend2D

MouseService.MouseMode = Enum.MouseMode.Free
MouseService.LockPosition = Vector3.zero
MouseService.CurrentCursor = '' -- gotta make sure this is read-only for Scripts >:3
-- honestly, we really need to add ScriptCapability shit anyway; but that'll be really annoyingggg :3

function MouseService.Init()
    MouseService.LoadCursorPack("Assets/Cursors/")
end

local CurrentCursorPack = {}

function MouseService.LoadCursorPack(Pack)
    for _, Name in pairs(love.filesystem.getDirectoryItems(Pack)) do
        CurrentCursorPack[string.sub(Name, 0,-5)] = love.mouse.newCursor(Pack..Name,0,0)
    end
end

MouseService.ClientUsingCursor = false

function MouseService.ChangeCursorInternal(ChangeTo, InternalCall)
    if MouseService.ClientUsingCursor and InternalCall then return end -- ass way to do this but whatever bro

    love.mouse.setCursor(CurrentCursorPack[ChangeTo])
    --print("Cursor Changed to: "..ChangeTo)
end

function MouseService.ChangeCursor(ChangeTo)
    MouseService.ClientUsingCursor = (ChangeTo ~= "Main")

    MouseService.CurrentCursor = ChangeTo
    MouseService.ChangeCursorInternal(ChangeTo)
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