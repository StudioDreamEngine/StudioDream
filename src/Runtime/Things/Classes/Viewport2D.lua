local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Viewport2D = Things.Extend("BaseGui")

function Viewport2D:New()
    self.super:New()

    self.Adornee = nil
    self.ViewportCanvas = nil
end

-- Send a child to be drawn by the rendering engine
function Viewport2D:SendChild(DrawFunction, Transform)
    
end

function Viewport2D:DrawContainerChildren(Transform, Container)
    for _, Child in pairs(self:GetChildren()) do
        
    end
end

function Viewport2D:Update(dt)
    local BaseTransform = Transform2D.new()
    Viewport2D:DrawContainerChildren(BaseTransform, self)
end

return Viewport2D