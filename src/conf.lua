TITLE = "(Early Riser)"
-- Major.Minor.Patch
VERSION = "0.5.1"

VER_RENDER = VERSION..TITLE

FLAGS = {
    ModeTarget = "Studio", -- What this build's functionality should be, disables studio component if "ClientRuntime", enables studio if "Editor"
    Verbose = false,
    Compat = love.getVersion() < 12,
    DebugDraw = false
}

function love.conf(t)
    t.window.width = 1570
    t.window.height = 800
    t.window.depth = true
    t.console = true

    t.window.title = "StudioDream "..VER_RENDER.." - Untitled Project"
    t.window.icon = "/Assets/Icons/"..FLAGS.ModeTarget..".png"
    t.window.resizable = true
end