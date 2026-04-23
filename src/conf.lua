VERSION = "0.1.2"
-- FinalVersion.BetaVersion.TestVersion

function love.conf(t)
    t.window.width = 800
    t.window.height = 600

    t.window.title = "StudioDream "..VERSION.." - Untitled Project"
    t.window.icon = "/Assets/Icons/Engine/StudioIcon.png"
    t.window.resizable = true
    
end