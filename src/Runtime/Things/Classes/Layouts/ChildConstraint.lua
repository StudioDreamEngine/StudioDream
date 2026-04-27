local Things = Runtime.Things

---@class ChildConstraint: BaseConstraint
local ChildConstraint = Things.Extend("BaseConstraint")

function ChildConstraint:new()
    ChildConstraint.super.new(self)
end

function ChildConstraint:Bind()
    if self.Parent:IsA(self.ObjectFilter) then
        for _, Property in pairs(self.ConstraintProperties) do
            self.Parent:BindConstraint(self, Property) 
        end

        table.insert(self.Objects, self.Parent)
    end
end

return ChildConstraint