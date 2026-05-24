local CursorHandle = {}

local CurrentCursorPack = "Assets/Cursors/"

function CursorHandle.ChangeCursor(ChangeTo)
    love.mouse.setCursor(love.mouse.newCursor(CurrentCursorPack..ChangeTo..".png", 0,0))
    print("Cursor Changed to: "..ChangeTo)
end

return CursorHandle