local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Viewport = Things.Extend("BaseGui")

function Viewport:new()
    Viewport.super.new(self)

    self.Adornee = nil
    self.RenderFolder = nil -- idk what to name this

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, Vector2.one)
    self.DisplayList = {}
end

function Viewport:Draw()
    Renderer.ViewportManager.RenderCanvas(self)
end

-- Send a child to the display list
function Viewport:SendChild(Child, Transform, Order)
    Order = Order or #self.DisplayList+1

    self.DisplayList[Order] = {
        Child = Child,
        Transform = Transform
    }
end

function Viewport:SetAbsoluteSize(New)
    Viewport.super.SetAbsoluteSize(self, New)

    -- Manual cleanup just in case
    if self.ViewportCanvas then
        local Canvas = self.ViewportCanvas
        self.ViewportCanvas = nil

        Canvas:release()
        print("Attempted to dispose of viewport canvas")
    end

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, New)
end

return Viewport