-- Major.Minor.Patch
VERSION = "0.1.2"

FLAGS = {
    ModeTarget = "Editor" -- What this build's functionality should be, disables studio component if "Client", enables studio if "Editor"
}

function love.conf(t)
    t.window.width = 800
    t.window.height = 600

    t.window.title = "StudioDream "..VERSION.." - Untitled Project"
    t.window.icon = "/Assets/Icons/Engine/StudioIcon.png"
    t.window.resizable = true
end