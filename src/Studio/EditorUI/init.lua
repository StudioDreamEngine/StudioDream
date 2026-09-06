-- Handles the UI editor
local EditorUI = {}

function EditorUI.Init()
    EditorUI.Playtest = require("Studio.EditorUI.Playtest")
    EditorUI.Playtest.Init()
end

function EditorUI.GetViewportInternal()
    return Runtime.Things.RenderRoot
end

function EditorUI.RedrawEverything()
    --print(Studio.Theme.GetCurrentThemeInfo())
    local MasterViewport = EditorUI.GetViewportInternal()
    for i,v in pairs(MasterViewport:GetDescendants()) do
        if v.Draw then
            v:Draw()
        end
    end
end

function EditorUI.MoveWindow(Window,Pos)
    Studio.Layout.MoveWindow(Studio.Layout.GetHandle(Window),Pos)    
end

function EditorUI.MoveWindowByMouse(Window)
    EditorUI.MoveWindow(Window, Studio.Layout.GetMouseContext(Studio.Layout.GetHandle(Window).Container))
end

function EditorUI.ToggleWindow(Window,Visible)
    Studio.Layout.ToggleWindow(Studio.Layout.GetHandle(Window), Visible or (not Studio.Layout.GetHandle(Window).FullContainer.Visible))
end

return EditorUI