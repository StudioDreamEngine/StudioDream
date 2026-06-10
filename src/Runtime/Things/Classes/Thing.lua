-- Base class for things
local Things = Runtime.Things

---@class Thing: ClassicObject
local Thing = Object:extend()

-- Fired as soon as the object is initally created
function Thing:new()
    --[[
        This is used for the engine type, its so that other parts can know that THIS table is an instance, 
        This is not needed for other classes, MIKL...!

        - Bloctans :3
    ]]
    self.Type = "Thing"

    -- Check if the object itself can be serialized
    self.Serializable = true

    -- Check if the object will be serialized by its parents
    self.TruelySerializable = true

    self.ParentChanged = Signal:New("ParentChanged")
    self.ChildrenChanged = Signal:New("ChildrenChanged")

    self.PropertyChanged = Signal:New("SomethingChanged")
    self.AttributeChanged = Signal:New("AttributeChangedWow")

    self.Children = {}
    self.Parent = nil ---@type Thing
    self.Unreferenced = false

    self.WasParented = false

    self.UUID = CreateUUID()
    self.NumericalID = 0

    self.Overrides = {}

    self.Attributes = {}

    --[[self.Proxy.Info({
        Groups = {
            -- TODO
        },
        ConstraintUpdator = nil -- Function that constraints use on update for an object
    })]]
end

--[[
    Fired once the most basic parts of an object are initally configured (UUID, ClassName, API, Properties)
]]
function Thing:OnReady() end

-- Fired only during API dump and after inital creation
function Thing:DefineAPI()
    self.Proxy = Things.ObjectProxy.new()

    self.Proxy.Property("Thing Parent", "string Name")
    self.Proxy.Group("General", "Parent", "Name")

    self.Proxy.Group("Attributes")
end

--[[
    CONSTRAINTS
    A constraint is basically a system for overriding a certain property with the values given by something else
    
    You can bind a constraint, which sets up a property to be used as a constraint
    Only one object is allowed to use a constraint at once

    Then you can set a constraint, which will allow you to change the property value, without changing the real one
    (ASSUMING you were the last object that binded to that property)

    if you want to use the constraint, OR the regular version (depending on if a constaint exists for the property), 
    you can do Thing:GetProperty(Property)

    the idea is that theres 2 behaviors for this on the class side:
        - Children: Binds contraints to the children of the objects parent
        - Parent: Binds constraints to the parent only
]]
function Thing:BindConstraint(Object, Property)
    self.Overrides[Property] = {
        Object = Object,
        Value = nil
    }
end

function Thing:SetConstraint(Object, Property, Value, DontUpdate)
    local Current = self.Overrides[Property]

    if Current.Object == Object then
        if not DontUpdate then
            self.Proxy.ConstraintUpdator(self)
        end

        Current.Value = Value
    else
        print("Couldnt set constraint")
    end
end

function Thing:UnbindConstraints(Object)
    for Property, Data in pairs(self.Overrides) do
        if Data.Object.UUID == Object.UUID then
            self.Overrides[Property] = nil
        end
    end
end

function Thing:__tostring()
    return self.Name..": "..self.ClassName
end

function Thing:FindConstraintOfType(Type)
    for _, Data in pairs(self.Overrides) do
        if Data.Object:IsA(Type) then
            return Data.Object
        end
    end
end

function Thing:SetAttribute(Name,Value)
    self.Attributes[Name] = Value
    self.Proxy.Property(Name.." "..type(Value))
    self.Proxy.Group("Attributes",Name)
end

function Thing:GetAttribute(Name)
    return self.Attributes[Name]
end

function Thing:RemoveAttribute(Name)
    self.Attributes[Name] = nil
end

-- Get the property or the override for it
-- If you dont want the overriden property, dont use this
function Thing:GetProperty(Property)
    local HasOverride = (self.Overrides[Property] and self.Overrides[Property].Value)
    
    return HasOverride or self[Property]
end

function Thing:Destroy()
    Things.Remove(self)
end

function Thing:Clone() -- SHOULD be working idk why it inst
    local NewThing = Things.New(self.ClassName)
    for Property,Val in pairs(self.Proxy.Accessible) do 
        if self.Proxy.Types[Property] then
            Type = self[Property] 
            print(Property,Type)
            Things.SetProperty(NewThing,Property,Type)
        end
    end
end

function Thing:FindFirstAncestorWithClass(Class)
    return self:GetParentCallback(function(Object)
        return Object:IsA(Class)
    end)
end

--[[
    In certain cases, we may get something like a non-proxied version of an object returned, 
    first off, this should never happen, if it does, tell bloctans

    but, if regular comparison isnt working, use this
]]
function Thing:Is(Thing2)
    return (Thing.UUID == Thing2.UUID)
end

function Thing:GetParentCallback(Callback)
	local Parent = self
	
	repeat
        Parent = Parent.Parent

		-- We need to also be able to use the callback on the object iself
		if Parent and Callback(Parent) then
			break
		end
	until (not Parent)
	
	return Parent
end

function Thing:IsSerializable()
    return self.TruelySerializable
end

function Thing:CheckRecursion(NewParent)
    if (not NewParent) then return end

    if NewParent == self then
        return "Parent recursion: Attempted to parent to self"
    elseif NewParent:DescendantOf(self) then
        return "Parent recursion: Attempted to parent to descendant of self"
    end
end

-- Fired on inital parenting, might move to event later, called after ParentChanged and ChildrenChanged events are invoked
function Thing:OnInitalParent(NewParent) end

function Thing:SetParent(NewParent)
    local CouldRecurse = self:CheckRecursion(NewParent)

    if CouldRecurse then
        print(CouldRecurse)

        return false, CouldRecurse
    end

    local OldParent = self.Parent

    if OldParent then
        OldParent.ChildrenChanged.Invoke(Enum.Hierachy.Removed, self)
        OldParent.Children[self.UUID] = nil
    end

    if NewParent then
        NewParent.ChildrenChanged.Invoke(Enum.Hierachy.Added, self)
        NewParent.Children[self.UUID] = self
    end

    self.Parent = NewParent
    self.ParentChanged.Invoke()
    
    if (not self.WasParented) then self:OnInitalParent(NewParent) end
    self.WasParented = true

    return true
end

function Thing:DescendantOf(Object)
    return self:GetParentCallback(function(ParentObject)
        return ParentObject == Object
    end)
end

function Thing:IsA(ObjectType)
    return self:is(Things.Type(ObjectType))
end

function Thing:GetChildren()
    return self.Children
end

function Thing:OnRemove()
    self.Unreferenced = true
    self:SetParent()
    self:ClearAllChildren()
end

function Thing:GetDescendants()
    local ReturnedDescendants = {}

    local function GetDescendantsImpl(Object)
        for _, Descendant in pairs(Object:GetChildren()) do
            table.insert(ReturnedDescendants, Descendant)
            GetDescendantsImpl(Descendant)
        end
    end

    GetDescendantsImpl(self)

    return ReturnedDescendants
end

-- TODO: Also, couldnt we just call DescendantOf on the Descendant to check if the thing is an ancestor?
-- Idk what is this supost to do so im leaving it like this!!
function Thing:AncestorOf(Descendant)
end

function Thing:FindFirstChild(Name)
    for ChildUUID,_ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)

        if Child.Name == Name then
            return Child
        end
    end
end

function Thing:ClearAllChildren(NameFilter)
    NameFilter = NameFilter or {}

    for ChildUUID,_ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)

        if not table.find(NameFilter, Child.Name) then
            Child:OnRemove(NameFilter)
            self.Children[Child.UUID] = nil
        end
    end 
end

function Thing:Invalidate() end
function Thing:Update() end

return Thing