local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Viewport2D = Things.Extend("BaseGui")

function Viewport2D:new()
    Viewport2D.super.new(self)

    self.Adornee = nil
    self.RenderFolder = nil -- idk what to name this

    self.MousePosition = Vector2.zero

    self.Explorer = {
        Visible = true,
        Icon = "layout"
    }

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, Vector2.one * 1000)
    self.DisplayList = {}
end

local function SortByDepth(List)
	table.sort(List, function(a,b) return a.Layer < b.Layer end)
	return List
end

-- Send a child to the display list
function Viewport2D:SendChild(Child, Transform, Order)
    self.DisplayList[Order] = {
        Child = Child,
        Transform = Transform
    }
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

        if (not Child:IsA("Viewport2D")) then
            self:SubmitContainerChildren(ChildTransform, Child)
        end
    end
end

function Viewport2D:Draw()
    Renderer.ViewportManager.RenderCanvas(self)
end

-- Create the display list that will be used by the renderer
function Viewport2D:CreateDisplayList()
    self.CurrentOrder = 1

    local BaseTransform = Transform2D.new()
    self:SubmitContainerChildren(BaseTransform, self.RenderFolder or self)
end

function Viewport2D:SetAbsoluteSize(New)
    Viewport2D.super.SetAbsoluteSize(self, New)
    
    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, New)
end

function Viewport2D:Update(dt)
    Viewport2D.super.Update(self, dt)

    self:CreateDisplayList()
end

return Viewport2D