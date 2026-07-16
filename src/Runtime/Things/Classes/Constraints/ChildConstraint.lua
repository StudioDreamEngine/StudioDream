local Things = Runtime.Things

---@class ChildConstraint: BaseConstraint
local ChildConstraint = Things.Extend("BaseConstraint")

function ChildConstraint:new()
    ChildConstraint.super.new(self)
end

function ChildConstraint:Bind()
    self:BindObject(self.Parent)
end

return ChildConstraint