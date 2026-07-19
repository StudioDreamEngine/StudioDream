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

    self.FilterType = Enum.FilterType.Linear
end

function Viewport:DefineAPI()
    Viewport.super.DefineAPI(self)
    
    self.Proxy.Property("Thing RenderContainer", "Enum.FilterType FilterType")
    self.Proxy.Group("General", "RenderContainer", "FilterType")
end

function Viewport:Draw()
    Renderer.ViewportManager.RenderCanvas(self)
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

function Viewport:CreateNew()
    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, self.AbsoluteSize)
    self.ViewportCanvas:setFilter(self.FilterType, self.FilterType)
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
    else
        self.RenderContainer = nil
    end
end

function Viewport:GetTarget()
    return self.RenderContainer or self
end

function Viewport:SetAbsoluteSize(New)
    if New.Magnitude() < 10 then New = Vector2.new(10,10) end
    Viewport.super.SetAbsoluteSize(self, New)

    printVerbose("Queued viewport update for: "..self.Name)
    self:CreateNew()
end

return Viewport