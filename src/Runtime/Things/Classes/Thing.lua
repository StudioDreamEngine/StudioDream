-- Base class for things
local Things = Runtime.Things

---@class Thing: ClassicObject
local Thing = Object:extend()

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
    
    self.Proxy = Runtime.ObjectProxy.new()

    self.Children = {}
    self.Parent = nil ---@type Thing
    self.Unreferenced = false

    self.UUID = CreateUUID()
    self.NumericalID = 0

    self.Overrides = {}

    self.Explorer = {
        Visible = true,
        Icon = "Square"
    }

    self.Proxy.Property("Thing Parent", "string Name")
    --[[self.Proxy.Info({
        Groups = {
            -- TODO
        },
        ConstraintUpdator = nil -- Function that constraints use on update for an object
    })]]
end

--[[
    Binds a constraint
    a constraint is basically a system for overriding a certain property with the values given by something else
    
    We provide these basic functions for the contraints
    its up to the class itself to handle the rest, like unbinding on parent change and toggling

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

function Thing:SetConstraint(Object, Property, Value)
    local Current = self.Overrides[Property]

    if Current.Object == Object then
        self.Proxy.ConstraintUpdator(self)
        Current.Value = Value
    end
end

function Thing:UnbindConstraints(Object)
    for Property, Data in pairs(self.Overrides) do
        if Data.Object.UUID == Object.UUID then
            self.Overrides[Property] = nil
        end
    end
end

function Thing:FindConstraintOfType(Type)
    for _, Data in pairs(self.Overrides) do
        if Data.Object:IsA(Type) then
            return Data.Object
        end
    end
end

-- Get the property or the override for it
-- If you dont want the overriden property, dont use this
function Thing:GetProperty(Property)
    local HasOverride = (self.Overrides[Property] and self.Overrides[Property].Value)

    return HasOverride or self[Property]
end

function Thing:FindFirstAncestorWithClass(Class)
    return self:GetParentCallback(function(Object)
        return Object:IsA(Class)
    end)
end

-- From what I know, the == operator cannot have its behavior changed via metatables properly
-- This is the second best option.
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

-- Used for updating Thing.TruelySerializable
local function CheckSerializable(self)
    local Serializable = true

    ---@param ParentThing Thing
    self:GetParentCallback(function(ParentThing)
        if not (ParentThing.Serializable) and not (ParentThing:IsA("Root")) then
            Serializable = false
        end
    end)

    -- HACK: This could probably be a part of GetParentCallback, and doesnt need to be hacked in like this.
    -- Return false if object itself isnt serializable
    if (not self.Serializable) then
        return false
    end

    return Serializable
end

function Thing:IsSerializable()
    return self.TruelySerializable
end

function Thing:SetParent(NewParent)
    if NewParent == self then
        error("Cannot parent Thing to itself.")
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

    self.TruelySerializable = CheckSerializable(self)
    self.ParentChanged.Invoke()
end

function Thing:DescendantOf()
    local ReturnedDescendant = {}

    -- We should improve this, maybe getchildren with a callback>?
    local function GetChildOf(ThingTo)
        for ChildUUID, _ in pairs(ThingTo.Children) do
            local Child = Things.Get(ChildUUID) -- dont forget this is a thing!!#@!@
            table.insert(ReturnedDescendant, Child)
            if ThingTo.Children then
                GetChildOf(ThingTo)
            end
        end
    end
    
    GetChildOf(self)

    return ReturnedDescendant
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

function Thing:Update() end

return Thing