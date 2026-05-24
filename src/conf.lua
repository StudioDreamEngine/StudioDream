-- Major.Minor.Patch
VERSION = "0.3.2"

FLAGS = {
    ModeTarget = "Studio", -- What this build's functionality should be, disables studio component if "ClientRuntime", enables studio if "Editor"
    Verbose = true
}

function love.conf(t)
    t.window.width = 800
    t.window.height = 600

    t.window.title = "StudioDream "..VERSION.." - Untitled Project"
    t.window.icon = "/Assets/Icons/"..FLAGS.ModeTarget..".png"
    t.window.resizable = true
end