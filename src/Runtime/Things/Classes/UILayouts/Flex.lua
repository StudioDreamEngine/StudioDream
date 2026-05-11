local Things = Runtime.Things

-- Someth simillar to css flex ig
-- For now, a flex object simply inherits the rest of the list layouts size

---@class FlexItem: ChildConstraint
local FlexItem = Things.Extend("ChildConstraint")

function FlexItem:new()
    FlexItem.super.new(self)

    self.ConstraintProperties = {"Size"}
    self.ObjectFilter = "BaseGui"
end

function FlexItem:GetListLayout()
    return self.Parent:FindConstraintOfType("ListLayout")
end

function FlexItem:Update(dt)
    self.super.Update(self, dt)

    ---@diagnostic disable-next-line: assign-type-mismatch
    local Target = self.Parent ---@type BaseGui

    local ListLayout = self:GetListLayout()
    if (not ListLayout) then return end

    Target:SetConstraint(self, "Size", ListLayout.RemainingSize)
end

return FlexItem