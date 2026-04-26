local Things = Runtime.Things

---@class ListLayout
---@module "Layouts.ParentConstraint"
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"}
    self.ObjectFilter = "BaseGui"
    self.Direction = Enum.LayoutDirection.Vertical
end

return ListLayout