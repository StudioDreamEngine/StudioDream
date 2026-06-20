local Things = Runtime.Things
local Renderer = Runtime.Renderer

---@class Viewport2D: Viewport
local Viewport2D = Things.Extend("Viewport")

function Viewport2D:new()
    Viewport2D.super.new(self)

    self.MousePosition = Vector2.zero

    self.TopLayer = {}
    self.Hovering = nil
    self.RenderFolder = nil
end

function Viewport2D:DefineAPI()
    Viewport2D.super.DefineAPI(self)

    self.Proxy.Property("Thing RenderFolder")
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

function Viewport2D:SubmitChild(Child)
    self.CurrentOrder = self.CurrentOrder + 1

    Child.AbsoluteLayer = self.CurrentOrder

    Utils.AssertType(Child.Position, "Pivot2D", Child.Name)

    -- Check if the viewport has given a request to update the transforms
    self:SendChild(Child, self.CurrentOrder)

    if (not Child:IsA("Viewport")) then
        self:SubmitContainerChildren(Child)
    end
end

-- Submit the children of an object/thing to the display list
function Viewport2D:SubmitContainerChildren(Container)
    --[[
        We need to sort every child based on their layer before submitting anything
        This is not much of a HACK, but it's a clever way of doing z-indexing with the way rendering is setup
        
        - Bloctans
    ]]
    local SortedChildren = SortByDepth(Container:GetChildren())
    
    for _, Child in pairs(SortedChildren) do
        if Child:IsAlwaysOnTop() then
            table.insert(self.TopLayer, Child)
        else
            self:SubmitChild(Child)
        end
    end
end

-- Create the display list that will be used by the renderer
function Viewport2D:CreateDisplayList()
    self.CurrentOrder = 1
    self.DisplayList = {}
    self.TopLayer = {}
    
    self:SubmitContainerChildren(self.RenderFolder or self)

    -- Now submit our objects that are supposed to be always on top
    for _, Child in pairs(self.TopLayer) do
        self:SubmitChild(Child)
    end
end

--[[function Viewport2D:HandleHovering()
    if Utils.IntersectPoint2D(self:GetRect(), self.MousePosition) then
            
    end
end]]

function Viewport2D:Update(dt)
    Viewport2D.super.Update(self, dt)

    self:CreateDisplayList()

    --[[local CurrentHovering, CurrentHoveringLayer = nil, 0

    for _, Object in pairs(self.DisplayList) do
    
    end]]
end

return Viewport2D