-- Handles the UI editor
local EditorUI = {}

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

return EditorUI