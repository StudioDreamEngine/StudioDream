VERSION = "0.1"

function love.conf(t)
    t.window.width = 800
    t.window.height = 600

    t.window.title = "StudioDream "..VERSION.." - Untitled Project"
    t.window.icon = "/Assets/Icons/Engine/EngineLogo.png"
end