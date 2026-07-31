-- Major.Minor.Patch
VERSION = "0.8.5"
TITLE = "(Early Riser)"
VERSION_FULL = VERSION.." "..TITLE

DEFAULT_FLAGS = {
    Target = "Studio", -- What this build's functionality should be, disables studio component if "ClientRuntime", enables studio if "Editor"
    Verbose = false,
    DebugDraw = true,
    ExternalOutput = true
}

function love.conf(t)
    t.window.width = 1570
    t.window.height = 800
    t.window.depth = true
    t.console = true

    t.version = "12.0"
    t.window.title = "StudioDream "..VERSION_FULL.." - No Project"
    t.window.resizable = true
end