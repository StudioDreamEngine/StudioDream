---@diagnostic disable: param-type-mismatch, need-check-nil
local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@class Viewport: Square
local Viewport = Things.Extend("Square")

function Viewport:new()
    Viewport.super.new(self)

    self.RenderContainer = nil -- idk what to name this

    self.Shader = Runtime.Shaders.Final()

    self.FilterType = Enum.FilterType.Linear
    self:CreateNew()

    self.DisplayList = {}

    self.BackgroundTransparency = 1
    self.ForegroundColor = Color.new(1,1,1)
end

function Viewport:DefineAPI()
    Viewport.super.DefineAPI(self)
    
    self.Proxy.SetCategory("Viewport")

    self.Proxy.Property("Thing RenderContainer", "Enum.FilterType FilterType")
    self.Proxy.Group("General", "RenderContainer", "FilterType")
end

function Viewport:GetCanvas()
    return {self.ViewportCanvas, self.MatCanvas, depthstencil=self.StencilCanvas}
end

function Viewport:Draw()
    Viewport.super.Draw(self)

    self:SetColor("Foreground", "Color")
    Renderer.ViewportManager.RenderCanvas(self)

    if FLAGS.DebugDraw then
        love.graphics.circle("fill", self.MousePosition.X, self.MousePosition.Y, 5)
        love.graphics.setFont(DebugFont)
        love.graphics.print(self:GetPath(), self.MousePosition.X, self.MousePosition.Y)
    end
end

-- Send a child to the display list
function Viewport:SendChild(Child, Order)
    Order = Order or #self.DisplayList+1

    self.DisplayList[Order] = Child
end

function Viewport:SetFilterType(New)
    self.FilterType = New
    self:CreateNew()
end

function Viewport:OnRemove()
    Viewport.super.OnRemove(self)
    self.Shader:release()
end

function Viewport:CreateNew()
    if self.ViewportCanvas then
        self.ViewportCanvas:release()
        self.StencilCanvas:release()
        self.MatCanvas:release()
    end

    self.ViewportCanvas, self.StencilCanvas, self.MatCanvas = Renderer.ViewportManager.CreateViewport(self, self.AbsoluteSize)
    self.ViewportCanvas:setFilter(self.FilterType, self.FilterType)

    --self.Shader:send("mat_canvas", self.MatCanvas)
end

---@param NewFolder Thing
function Viewport:SetRenderContainer(NewFolder)
    if (not NewFolder) then print("newfolder is nil") return end

    if NewFolder and NewFolder:IsA("ViewportContainer") then
        if (not NewFolder.Adornee) then
            NewFolder.Adornee = self
        else
            print("Adornee of ViewportContainer was not automatically set, as it already has an adornee. \nSet it to nil before configuring a new one.")
        end
    
        self.RenderContainer = NewFolder
        self:InvalidateRendering()
    else
        self.RenderContainer = nil
    end
end

function Viewport:GetTarget()
    return self.RenderContainer or self
end

function Viewport:SetAbsoluteSize(New)
    if New:Magnitude() < 10 then New = Vector2.new(10,10) end
    Viewport.super.SetAbsoluteSize(self, New)

    printVerbose("Queued viewport update for: "..self.Name)
    self:CreateNew()
end

return Viewport