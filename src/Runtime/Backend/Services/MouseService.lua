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

-- Load a folder containing the cursors to use
function MouseService.LoadCursorPack(Pack)
    for _, Name in pairs(love.filesystem.getDirectoryItems(Pack)) do
        CurrentCursorPack[string.sub(Name, 0,-5)] = love.mouse.newCursor(Pack..Name,0,0)
    end
end

MouseService.ClientUsingCursor = false

--[[
    Internal function used for changing the cursor itself
    
    this is a really bad way to do this, however it allows for the InterfaceManager 
    to override if the mouse is hovering ONLY if the current cursor being used is 
    the main cursor
]]
function MouseService.ChangeCursorInternal(ChangeTo, InternalCall)
    if MouseService.ClientUsingCursor and InternalCall then return end -- ass way to do this but whatever bro

    love.mouse.setCursor(CurrentCursorPack[ChangeTo])
    --print("Cursor Changed to: "..ChangeTo)
end

--[[
    Change the current cursor being used
    
    if the cursor is anything but the main one, this will also override the hovering cursor when hovering over a button, 
    as explained above.
]]
function MouseService.ChangeCursor(ChangeTo)
    MouseService.ClientUsingCursor = (ChangeTo ~= "Main")

    MouseService.CurrentCursor = ChangeTo
    MouseService.ChangeCursorInternal(ChangeTo)
end

-- Get the current mouse position on screen
function MouseService.GetPosition()
    return Backend2D.GetMousePosition()
end

-- Change if the mouse is locked or free to move around
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