local Shared = require("Shared")
local Editor = require("Editor")

function love.load()
    Shared.Init()
    Editor.Init()
end

function love.draw()
    Editor.Render()
end

function love.update(dt)
    Editor.Update(dt)
    Shared.Update(dt)
end