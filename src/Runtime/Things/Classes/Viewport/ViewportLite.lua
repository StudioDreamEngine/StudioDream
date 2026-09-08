local Things = Runtime.Things
local Renderer = Runtime.Renderer

---@class ViewportLite: Viewport
local ViewportLite = Things.Extend("Viewport")

function ViewportLite:new()
    ViewportLite.super.new(self)

    self.MousePosition = Vector2.zero

    self.TopLayer = {}
    self.Hovering = nil
end

function ViewportLite:DefineAPI()
    ViewportLite.super.DefineAPI(self)

    self.Proxy.Property("Thing RenderContainer")
    self.Proxy.Icon("Viewport_2D")
    self.Proxy.MakeCreatable()
end

local function SortFunc(a,b) return a.Layer < b.Layer end

function ViewportLite:SubmitChild(Child)
    self.CurrentOrder = self.CurrentOrder + 1
    Child.AbsoluteLayer = self.CurrentOrder + self.AbsoluteLayer
    -- Check if the viewport has given a request to update the transforms
    self:SendChild(Child, self.CurrentOrder)

    if (not Child:IsA("Viewport")) then
        self:SubmitContainerChildren(Child)
    end
end

-- Submit the children of an object/thing to the display list
function ViewportLite:SubmitContainerChildren(Container)
    --[[
        We need to sort every child based on their layer before submitting anything
        This is not much of a HACK, but it's a clever way of doing z-indexing with the way rendering is setup
        
        - Bloctans
    ]]
    local InterfaceChildren = Container:GetInterfaceChildren()
    table.sort(InterfaceChildren, SortFunc)

    for _, Child in pairs(InterfaceChildren) do
        if Child:IsAlwaysOnTop() then
            table.insert(self.TopLayer, Child)
        elseif Child.TruelyVisible then
            self:SubmitChild(Child)
        end
    end
end

function ViewportLite:ProcessInvalidation(Origin)
    ViewportLite.super.ProcessInvalidation(self, Origin)

    if self.RenderContainer then
        self.RenderContainer:ProcessInvalidation(Origin)
    end
end

-- Create the display list that will be used by the renderer
function ViewportLite:CreateDisplayList()
    self.CurrentOrder = 1

    table.clear(self.DisplayList)
    table.clear(self.TopLayer)
    
    self:SubmitContainerChildren(self.RenderContainer or self)

    -- Now submit our objects that are supposed to be always on top
    for _, Child in pairs(self.TopLayer) do
        self:SubmitChild(Child)
    end
end

function ViewportLite:Update(dt)
    ViewportLite.super.Update(self, dt)

    Profiler.Start("ViewportLite - Create Display List")
    self:CreateDisplayList()
    Profiler.End()
end

return ViewportLite