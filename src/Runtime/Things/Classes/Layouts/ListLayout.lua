local Things = Runtime.Things

---@class ListLayout: ParentConstraint
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"}
    self.ObjectFilter = "BaseGui"

    self.Direction = Enum.LayoutDirection.Vertical
    self.Padding = 0

    self.RemainingSize = 0
end

function ListLayout:Update()
    ListLayout.super.Update(self)

    local ListPos = 0

    table.sort(self.Objects, function (a, b)
        return (a.ListOrder < b.ListOrder)
    end)

    local Vertical = (self.Direction == Enum.LayoutDirection.Vertical)
    local TotalSpace = self.Parent.AbsoluteSize[Vertical and "X" or "Y"]

    ---@param Object BaseGui
    for _, Object in pairs(self.Objects) do
        if Vertical then
            self:SetConstraint(Object, "Position", Pivot2D.FromOffset(0,ListPos))
            ListPos = ListPos + Object.AbsoluteSize.Y + self.Padding
        else
            self:SetConstraint(Object, "Position", Pivot2D.FromOffset(ListPos,0))
            ListPos = ListPos + Object.AbsoluteSize.X + self.Padding
        end
    end

    -- Temporary, change in the future PLEASE
    self.Parent:UpdateChildTransforms()

    self.RemainingSize = TotalSpace - (ListPos - self.Padding)
end

return ListLayout