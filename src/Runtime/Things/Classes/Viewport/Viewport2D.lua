local Things = Runtime.Things
local Renderer = Runtime.Renderer

---@class Viewport2D: Viewport
local Viewport2D = Things.Extend("Viewport")

function Viewport2D:new()
    Viewport2D.super.new(self)

    self.MousePosition = Vector2.zero

    self.TopLayer = {}
    self.Hovering = nil
end

function Viewport2D:DefineAPI()
    Viewport2D.super.DefineAPI(self)

    self.Proxy.Property("Thing RenderContainer")
    self.Proxy.Icon("Viewport_2D")
    self.Proxy.MakeCreatable()
end

local function SortByDepth(List)
    local TempList = {}

    for _, Child in pairs(List) do
        if Child:IsA("BaseGui") then
            table.insert(TempList, Child)
        end
    end

	table.sort(TempList, function(a,b) return a.Layer < b.Layer end)
	return TempList
end

function Viewport2D:SendChild(Child)
    self.CurrentOrder = self.CurrentOrder + 1
    Child.AbsoluteLayer = self.CurrentOrder + self.AbsoluteLayer

    Utils.AssertType(Child.Position, "Pivot2D", Child.Name)

    -- Check if the viewport has given a request to update the transforms
    Viewport2D.super.SendChild(self, Child, self.CurrentOrder)
end

-- Submit the children of an thing and the thing itself to the display list
-- Initial: If the container is a viewport or not
function Viewport2D:SubmitContainerChildren(Container, Initial)
    --[[
        We need to sort every child based on their layer before submitting anything
        This is not much of a HACK, but it's a clever way of doing z-indexing with the way rendering is setup
        
        - Bloctans
    ]]
    Profiler.Start("Viewport2D - SubmitContainerChildren")

    local SortedChildren = SortByDepth(Container:GetChildren())
    local RenderBehind, RenderAbove = {}, {}

    if Initial or (not Container:IsA("Viewport2D")) then
        for _, Child in pairs(SortedChildren) do
            if Child:IsAlwaysOnTop() then
                table.insert(self.TopLayer, Child)
            elseif Child.TruelyVisible then
                table.insert((Child.Layer < 0) and RenderBehind or RenderAbove, Child)
            end
        end

        SortedChildren = nil
    end

    self:SubmitPasses(RenderBehind, Initial and {} or {Container}, RenderAbove)

    Profiler.End()

    return RenderBehind, RenderAbove
end

function Viewport2D:SubmitChildrenPass(Table, Submit) 
    for _, Child in pairs(Table) do 
        if Submit then 
            self:SubmitContainerChildren(Child)
        else
            self:SendChild(Child)
        end
    end 
end

-- Submit the "Passes" (Behind, Child and Above) seperately
function Viewport2D:SubmitPasses(Behind, Child, Above)
    Profiler.Start("Viewport2D - SubmitPasses")

    self:SubmitChildrenPass(Behind, true)
    self:SubmitChildrenPass(Child)
    self:SubmitChildrenPass(Above, true)

    Profiler.End()
end

function Viewport2D:ProcessInvalidation(Origin)
    Viewport2D.super.ProcessInvalidation(self, Origin)

    if self.RenderContainer then
        Profiler.Start("Viewport2D - RenderContainer Invalidation")
            self.RenderContainer:ProcessInvalidation(Origin)
        Profiler.End()
    end
end

-- Create the display list that will be used by the renderer
function Viewport2D:CreateDisplayList()
    self.CurrentOrder = 1
    self.DisplayList = {}
    self.TopLayer = {}
    
    self:SubmitContainerChildren(self.RenderContainer or self, true)

    -- Now submit our objects that are supposed to be always on top
    for _, Child in pairs(self.TopLayer) do
        self:SubmitContainerChildren(Child)
    end
end

function Viewport2D:Update(dt)
    Viewport2D.super.Update(self, dt)

    Profiler.Start("Viewport2D - Create Display List")
    self:CreateDisplayList()
    Profiler.End()
end

return Viewport2D