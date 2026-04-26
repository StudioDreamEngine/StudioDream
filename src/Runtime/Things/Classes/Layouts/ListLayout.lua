local Things = Runtime.Things

---@class ListLayout
---@module "Layouts.ParentConstraint"
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"}
    self.ObjectFilter = "BaseGui"

    self.Direction = Enum.LayoutDirection.Vertical
    self.Padding = 20
end

function ListLayout:Update()
    local ListPos = 0

    ---@param Object BaseGui
    for _, Object in pairs(self.Objects) do
        ListPos = ListPos + Object.AbsoluteSize.Y + self.Padding

        self:SetConstraint(Object, "Position", Pivot2D.FromOffset(0,ListPos))
    end
end

return ListLayout