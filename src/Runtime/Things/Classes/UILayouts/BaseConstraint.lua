-- Base object for the constraint system, How they work is documented alongside the functions for them in Thing
local Things = Runtime.Things

---@class BaseConstraint: Thing
local BaseConstraint = Things.Extend("Thing")

function BaseConstraint:new()
    BaseConstraint.super.new(self)

    self.ConstraintProperties = {} -- These are the properties that will be controled by the object
    self.ObjectFilter = "BaseConstraint" -- These are the objects that can be binded, if an object that isnt this is passed into BindObject, its ignored

    self.Objects = {}
end

function BaseConstraint:Bind()
    error("BaseConstraint:Bind() is a virtual function, and cannot be called, override the function to use it")
end

-- Binds an object to the constraint, making it so that what is in ConstraintProperties is now controled by this object
function BaseConstraint:BindObject(Object)
    if (not Object:IsA(self.ObjectFilter)) then
        return
    end

    for _, Property in pairs(self.ConstraintProperties) do
        Object:BindConstraint(self, Property) 
    end

    table.insert(self.Objects, Object)

    return true
end

function BaseConstraint:UnbindObject(Object)
    table.removeValue(self.Objects, Object)
    Object:UnbindConstraints(self)
end

-- Unbind all objects
function BaseConstraint:Unbind()
    for _, Object in pairs(self.Objects) do
        self:UnbindObject(Object)
    end
end

-- Shortcut function
function BaseConstraint:SetConstraint(Object, Property, Value)
    Object:SetConstraint(self, Property, Value)
end

-- Make sure we un-bind and re-bind all objects on parent change
function BaseConstraint:SetParent(NewParent)
    self:Unbind()
    BaseConstraint.super.SetParent(self, NewParent)

    if NewParent then
        self:Bind()
    end
end

return BaseConstraint