local Things = Runtime.Things
local Renderer = Runtime.Renderer

-- using @module here gives the lua language server a base type to use!
---@module 'BaseGui'
local Viewport2D = Things.Extend("BaseGui")

function Viewport2D:New()
    self.super:New()

    self.Adornee = nil
    self.RenderFolder = nil -- idk what to name this

    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, Vector2.one * 100)

    self.DisplayList = {}
end

local function SortByDepth(List)
	table.sort(List, function(a,b)
		--[[if (a.Layer == b.Layer) then
			return (a.GetPosition().Y < b.GetPosition().Y)
		else]]
		return a.Layer < b.Layer
		--end
	end)

	return List
end

-- Send a child to the display list
function Viewport2D:SendChild(Child, Transform, Order)
    self.DisplayList[Order] = {
        Child = Child,
        Transform = Transform
    }
end

function Viewport2D:DrawContainerChildren(Transform, Container)
    local SortedChildren = SortByDepth(Container:GetChildren())

    for _, Child in pairs(SortedChildren) do
        self.CurrentOrder = self.CurrentOrder + 1

        local Position = Child.Position.Offset + (Child.Position.Scale * Container.AbsoluteSize)
        Transform:translate(Position.X, Position.Y)

        self:SendChild(Child, Transform, self.CurrentOrder)

        --self:DrawContainerChildren(Transform:clone(), Child)
    end
end

function Viewport2D:CreateDisplayList()
    self.DisplayList = {}
    self.CurrentOrder = 1 -- idk why but refuses to work outside of this function???

    local BaseTransform = Transform2D.new()
    self:DrawContainerChildren(BaseTransform, self.RenderFolder or self)
end

function Viewport2D:Update(dt)
    self.super:Update(dt)
    self:CreateDisplayList()

    -- TODO: Figure out how to make an OnChanged event for this stuff
    self.ViewportCanvas = Renderer.ViewportManager.CreateViewport(self, self.AbsoluteSize)
end

return Viewport2D