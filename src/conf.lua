TITLE = "(Early Riser)"
-- Major.Minor.Patch
VERSION = "0.4.3 "..TITLE

FLAGS = {
    ModeTarget = "Studio", -- What this build's functionality should be, disables studio component if "ClientRuntime", enables studio if "Editor"
    Verbose = false,
    Compat = love.getVersion() < 12,
    DebugDraw = false
}

function love.conf(t)
    t.window.width = 1570
    t.window.height = 800
    t.window.depth = 24

    t.window.title = "StudioDream "..VERSION.." - Untitled Project"
    t.window.icon = "/Assets/Icons/"..FLAGS.ModeTarget..".png"
    t.window.resizable = true
end