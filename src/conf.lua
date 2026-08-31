-- Major.Minor.Patch
VERSION = "0.10"
TITLE = "(Early Riser)"
VERSION_FULL = VERSION.." "..TITLE

-- It's reccommended to no longer change these, you should instead use the command line arguments (StudioDream --Help)
DEFAULT_FLAGS = require("flags")

function love.conf(t)
    t.window.width = 1570
    t.window.height = 800
    t.window.depth = true
    t.console = true

    t.version = "12.0"
    t.window.title = "StudioDream "..VERSION_FULL.." - No Project"
    t.window.resizable = true
    
    t.identity = "StudioDream"
end