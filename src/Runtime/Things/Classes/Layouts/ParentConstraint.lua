local Things = Runtime.Things

---@class ParentConstraint
---@module "BaseConstraint"
local ParentConstraint = Things.Extend("BaseConstraint")

function ParentConstraint:new()
    ParentConstraint.super.new(self)

    self.Objects = {}
end

function ParentConstraint:Bind()
    for _, Object in pairs(self.Parent:GetChildren()) do
        if Object:IsA(self.ObjectFilter) then
            for _, Property in pairs(self.ConstraintProperties) do
                Object:BindConstraint(self, Property) 
            end

            table.insert(self.Objects, Object)
        end
    end
end

return ParentConstraint