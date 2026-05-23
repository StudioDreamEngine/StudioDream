local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@class Viewport2D: Viewport
local Viewport2D = Things.Extend("Viewport")

function Viewport2D:new()
    Viewport2D.super.new(self)

    self.MousePosition = Vector2.zero
    self.InitalInvalidation = false

    self.TopLayer = {}

    self.Explorer = {
        Visible = true,
        Icon = "Viewport_2D"
    }
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

function Viewport2D:Update(dt)
    Viewport2D.super.Update(self, dt)

    self:CreateDisplayList()

    if (not self.InitalInvalidation) then
        self.InitalInvalidation = true
        self:InvalidateRendering()
    end
end

return Viewport2D