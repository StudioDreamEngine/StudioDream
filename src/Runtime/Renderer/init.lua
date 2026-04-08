local Render = {}

Render.ViewportManager = require("Runtime.Renderer.ViewportManager")

local Backend3D
--Render.UIRender = require("Runtime.Renderer.UIRender")

function Render.Init()
    Backend3D = Runtime.Backend3D

    Backend3D.Init()
    Render.ViewportManager.Init()
end

function Render.Render()
    Backend3D.Render()
    Render.ViewportManager.Render()
end

return Render