local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
---@class Viewport
local Viewport = Things.Extend("BaseGui")

function Viewport:new()
    Viewport.super.new(self)

    self.Adornee = nil
    self.RenderFolder = nil -- idk what to name this

    self.QueuedUpdate = false

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, Vector2.one)
    self.DisplayList = {}
end

function Viewport:Draw()
    Renderer.ViewportManager.RenderCanvas(self)
end

-- Send a child to the display list
function Viewport:SendChild(Child, Order)
    Order = Order or #self.DisplayList+1

    self.DisplayList[Order] = {
        Child = Child
    }
end

function Viewport:SetAbsoluteSize(New)
    Viewport.super.SetAbsoluteSize(self, New)

    print("Queued viewport update for: "..self.Name)
    self.QueuedUpdate = true

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, New)
end

return Viewport