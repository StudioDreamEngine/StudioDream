local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@class Viewport: BaseGui
local Viewport = Things.Extend("BaseGui")

function Viewport:new()
    Viewport.super.new(self)

    self.RenderContainer = nil -- idk what to name this

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, Vector2.one)
    self.DisplayList = {}
end

function Viewport:DefineAPI()
    Viewport.super.DefineAPI(self)
    
    self.Proxy.Property("Thing RenderContainer")
    self.Proxy.Group("General", "RenderContainer")
end

function Viewport:Draw()
    Renderer.ViewportManager.RenderCanvas(self)
end

-- Send a child to the display list
function Viewport:SendChild(Child, Order)
    Order = Order or #self.DisplayList+1

    self.DisplayList[Order] = Child
end

---@param NewFolder Thing
function Viewport:SetRenderContainer(NewFolder)
    if (not NewFolder) then print("newfolder is nil") return end

    if NewFolder:IsA("ViewportContainer") then
        NewFolder.Adornee = self
        self.RenderContainer = NewFolder
    else
        print("Couldnt set RenderContainer, RenderContainer isnt a ViewportContainer or subclass")
    end
end

function Viewport:GetTarget()
    return self.RenderContainer or self
end

function Viewport:SetAbsoluteSize(New)
    Viewport.super.SetAbsoluteSize(self, New)

    printVerbose("Queued viewport update for: "..self.Name)
    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, New)
end

return Viewport