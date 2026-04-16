local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Viewport2D = Things.Extend("Viewport")

function Viewport2D:new()
    Viewport2D.super.new(self)

    self.MousePosition = Vector2.zero

    self.Explorer = {
        Visible = true,
        UseNewIcon = true,
        Icon = "Viewport_2D"
    }
end

local function SortByDepth(List)
	table.sort(List, function(a,b) return a.Layer < b.Layer end)
	return List
end

-- Submit the children of an object/thing to the display list
function Viewport2D:SubmitContainerChildren(Container)
    --[[
        We need to sort every child based on their layer before submitting anything
        This is not much of a HACK, as it is a clever way of doing z-indexing with the way rendering is setup
        
        - Bloctans
    ]]
    local SortedChildren = SortByDepth(Container:GetChildren())
    
    for _, Child in pairs(SortedChildren) do
        self.CurrentOrder = self.CurrentOrder + 1

        Utils.AssertType(Child.Position, "Pivot2D", Child.Name)

        -- Check if the viewport has given a request to update the transforms
        if self.QueuedUpdate then
            Child:UpdateTransforms()
        end

        self:SendChild(Child, self.CurrentOrder)

        if (not Child:IsA("Viewport")) then
            self:SubmitContainerChildren(Child)
        end
    end
end

-- Create the display list that will be used by the renderer
function Viewport2D:CreateDisplayList()
    self.CurrentOrder = 1
    self:SubmitContainerChildren(self.RenderFolder or self)
    self.QueuedUpdate = false
end

function Viewport2D:Update(dt)
    Viewport2D.super.Update(self, dt)

    self:CreateDisplayList()
end

return Viewport2D