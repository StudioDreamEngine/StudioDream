---@class RenderClient
local RenderClient = Object:extend()

---@param Viewport Viewport2D
---@param Server RenderServer
function RenderClient:new(Viewport, Server, Function)
    self.Viewport = Viewport
    self.Server = Server
    self.Function = Function
end

function RenderClient:GetSize()
    local x,y = self.Viewport.ViewportCanvas:getDimensions()

    return Vector2.new(x,y)
end

function RenderClient:Present()
    self.Function(self)
end

function RenderClient:Draw(RendererName, Info)
    love.graphics.push("all")
    if Info.Pivot then
        Info.Position = Info.Position - (Info.Size * Info.Pivot)
    end

    love.graphics.translate(Info.Position.X, Info.Position.Y)

    self.Server.GetRenderer(RendererName)(Info)
    love.graphics.pop()
end

return RenderClient