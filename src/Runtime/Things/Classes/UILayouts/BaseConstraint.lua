local Things = Runtime.Things

---@class BaseConstraint: Thing
local BaseConstraint = Things.Extend("Thing")

function BaseConstraint:new()
    BaseConstraint.super.new(self)

    self.ConstraintProperties = {}
    self.ObjectFilter = "BaseConstraint"

    self.Objects = {}
end

function BaseConstraint:Bind()
    error("BaseConstraint:Bind() is a virtual function, and cannot be called, override the function to use it")
end

function BaseConstraint:BindObject(Object)
    if (not Object:IsA(self.ObjectFilter)) then
        return
    end

    for _, Property in pairs(self.ConstraintProperties) do
        Object:BindConstraint(self, Property) 
    end

    table.insert(self.Objects, Object)
end

function BaseConstraint:UnbindObject(Object)
    table.removeValue(self.Objects, Object)
    Object:UnbindConstraints(self)
end

function BaseConstraint:Unbind()
    for _, Object in pairs(self.Objects) do
        self:UnbindObject(Object)
    end
end

function BaseConstraint:SetConstraint(Object, Property, Value)
    Object:SetConstraint(self, Property, Value)
end

function BaseConstraint:SetParent(NewParent)
    self:Unbind()
    BaseConstraint.super.SetParent(self, NewParent)

    -- TODO: Also re-bind all objects when a new object is added!
    if NewParent then
        self:Bind()
    end
end

return BaseConstraint