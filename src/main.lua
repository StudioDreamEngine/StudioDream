Shared = require("Shared")
Editor = require("Editor")
Runtime = require("Runtime")

function love.load()
    Shared.Init()
    Runtime.Init()
    Editor.Init()
end

function love.draw()
    Runtime.Renderer.Render()
    Editor.Render()
end

function love.update(dt)
    Editor.Update(dt)
    Runtime.Things.Update(dt)
    Shared.Update(dt)
end

