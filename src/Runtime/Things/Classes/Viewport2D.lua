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
        Icon = "layout"
    }
end

local function SortByDepth(List)
	table.sort(List, function(a,b) return a.Layer < b.Layer end)
	return List
end

-- Submit the children of an object/thing to the display list
function Viewport2D:SubmitContainerChildren(Transform, Container)
    --[[
        We need to sort every child based on their layer before submitting anything
        This is not much of a HACK, as it is a clever way of doing z-indexing with the way rendering is setup
        
        - Bloctans
    ]]
    local SortedChildren = SortByDepth(Container:GetChildren())

    for _, Child in pairs(SortedChildren) do
        self.CurrentOrder = self.CurrentOrder + 1

        local ChildTransform = Transform:clone()

        Utils.AssertType(Child.Position, "Pivot2D", Child.Name)

        local Position = Child:GetOffsetPosition()

        -- HACK: Transforming this independently from the AbsolutePosition code will cause desync when we start adding rotation ...Whatever!
        ChildTransform:translate(Position.X, Position.Y)

        self:SendChild(Child, ChildTransform, self.CurrentOrder)

        if (not Child:IsA("Viewport")) then
            self:SubmitContainerChildren(ChildTransform, Child)
        end
    end
end

-- Create the display list that will be used by the renderer
function Viewport2D:CreateDisplayList()
    self.CurrentOrder = 1

    local BaseTransform = Transform2D.new()
    self:SubmitContainerChildren(BaseTransform, self.RenderFolder or self)
end

function Viewport2D:Update(dt)
    Viewport2D.super.Update(self, dt)

    self:CreateDisplayList()
end

return Viewport2D