local Render = {}

Render.ViewportManager = require("Runtime.Renderer.ViewportManager")
--Render.UIRender = require("Runtime.Renderer.UIRender")

function Render.Init()
    Render.ViewportManager.Init()
end

function Render.Render()
    Render.ViewportManager.Render()
end

return Render