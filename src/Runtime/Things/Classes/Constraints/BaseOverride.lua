-- Base object for the Override system, How they work is documented alongside the functions for them in Thing
local Things = Runtime.Things

---@class BaseOverride: Thing
local BaseOverride = Things.Extend("Thing")

function BaseOverride:new()
    BaseOverride.super.new(self)

    self.OverrideProperties = {} -- These are the properties that will be controled by the object
    self.ObjectFilter = "BaseOverride" -- These are the objects that can be binded, if an object that isnt this is passed into BindObject, its ignored
    self.ParentFilter = "Thing"

    self.Objects = {}
end

function BaseOverride:Bind()
    error("BaseOverride:Bind() is a virtual function, and cannot be called, override the function to use it")
end

-- Binds an object to the Override, making it so that what is in OverrideProperties is now controled by this object
function BaseOverride:BindObject(Object)
    if (not Object:IsA(self.ObjectFilter)) or Object.IgnoreOverrides then
        return
    end

    for _, Property in pairs(self.OverrideProperties) do
        Object:BindOverride(self, Property) 
    end

    table.insert(self.Objects, Object)

    return true
end

function BaseOverride:Update()
    BaseOverride.super.Update(self)

    -- i guess bro
    for _, Object in pairs(self.Objects) do
        if Object.IgnoreOverrides then
            printVerbose("IgnoreOverrides object found in objects check, unbinding...")
            self:UnbindObject(Object)
        end
    end
end

function BaseOverride:UnbindObject(Object)
    table.removeValue(self.Objects, Object)
    Object:UnBindOverrides(self)
end

-- Unbind all objects
function BaseOverride:Unbind()
    for _, Object in pairs(self.Objects) do
        self:UnbindObject(Object)
    end
end

-- Shortcut function
function BaseOverride:SetOverride(Object, Property, Value, DontUpdate)
    Object:SetOverride(self, Property, Value, DontUpdate)
end

-- Make sure we un-bind and re-bind all objects on parent change
function BaseOverride:SetParent(NewParent)
    self:Unbind()
    local CouldParent, Reason = BaseOverride.super.SetParent(self, NewParent)

    if self.Parent and self.Parent:IsA(self.ParentFilter) then
        self:Bind()
    end

    return CouldParent, Reason
end

return BaseOverride