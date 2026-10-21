-- Handles the UI editor
local EditorUI = {}

function EditorUI.Init()
    EditorUI.Playtest = require("Studio.EditorUI.Playtest")
    EditorUI.Playtest.Init()
end

function EditorUI.GetViewportInternal()
    return Runtime.Things.RenderRoot
end

-- TODO: Move to layout???
function EditorUI.MoveWindow(Window, Pos, Ctx)
    Studio.Layout.MoveWindow(Studio.Layout.GetWindowHandle(Window), Pos, Ctx)   
end

function EditorUI.MoveWindowToMouse(Window)
    EditorUI.MoveWindow(Window, Studio.Layout.GetMouseContext(Studio.Layout.GetWindowHandle(Window).Container))
end

function EditorUI.ToggleWindow(Window,Visible)
    Studio.Layout.ToggleWindow(Studio.Layout.GetWindowHandle(Window), Visible or (not Studio.Layout.GetWindowHandle(Window).FullContainer.Visible))
end

return EditorUI