-- Major.Minor.Patch
VERSION = "0.6.2"
TITLE = "(Early Riser)"
VERSION_FULL = VERSION.." "..TITLE

FLAGS = {
    ModeTarget = "Studio", -- What this build's functionality should be, disables studio component if "ClientRuntime", enables studio if "Editor"
    Verbose = false,
    DebugDraw = false
}

function love.conf(t)
    t.window.width = 1570
    t.window.height = 800
    t.window.depth = true
    t.console = true

    t.version = "12.0"
    t.window.title = "StudioDream "..VERSION_FULL.." - Untitled Project"
    t.window.icon = "/Assets/Icons/"..FLAGS.ModeTarget..".png"
    t.window.resizable = true
end