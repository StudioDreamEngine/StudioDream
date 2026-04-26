local Things = Runtime.Things

---@class BaseConstraint
---@module "Thing"
local BaseConstraint = Things.Extend("Thing")

function BaseConstraint:new()
    BaseConstraint.super.new(self)

    self.ConstraintProperties = {}
    self.ObjectFilter = "BaseConstraint"
end

function BaseConstraint:Bind()
    error("BaseConstraint:Bind() is a virtual function, and cannot be called, override the function to use it")
end

function BaseConstraint:Unbind()
    for _, Object in pairs(self.Objects) do
        Object:UnbindConstraint(self)
    end
end

-- Might use idk
function BaseConstraint:SetConstraint(Object, Property, Value)
    Object:SetConstraint(self, Property, Value)
end

function BaseConstraint:SetParent(NewParent)
    self:Unbind()
    BaseConstraint.super.SetParent(self, NewParent)
    self:Bind()
end

return BaseConstraint