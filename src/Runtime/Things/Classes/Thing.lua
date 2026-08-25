-- Base class for things
local Things = Runtime.Things

---@class Thing: ClassicObject
local Thing = Object:extend()

local ObjectsCreated = 0

-- Fired as soon as the object is initally created
function Thing:new()
    --[[
        This is used for the engine type, its so that other stuff can know that THIS table is an instance/thing, 
        This is not needed for other classes, MIKL...!

        - Bloctans :3
    ]]
    self.Type = "Thing"
    self.OrphanedPath = "Created"

    -- Check if the object itself can be serialized
    self.Serializable = true

    -- Check if the object will be serialized by its parents
    self.TruelySerializable = true

    -- Heierarchy
    self.ParentChanged = Signal:New("ParentChanged")
    self.ChildrenChanged = Signal:New("ChildrenChanged")

    -- Change events
    self.PropertyChanged = Signal:New("SomethingChanged")
    self.AttributeChanged = Signal:New("AttributeChangedWow")

    self.OnDestroy = Signal:New("OnDestroy")

    self.Children = {}
    self.InterfaceChildren = {}

    self.Parent = nil ---@type Thing
    self.Unreferenced = false

    self.WasParented = false

    ObjectsCreated = ObjectsCreated + 1

    self.UUID = CreateUUID()
    self.NumericalID = ObjectsCreated

    self.Overrides = {}

    self.Attributes = {}

    self.PlaceholderSignals = {}
    --[[self.Proxy.Info({
        Groups = {
            -- TODO
        },
        ConstraintUpdator = nil -- Function that constraints use on update for an object
    })]]
end

function Thing:AddPlaceholderSignal(Signal)
    table.insert(self.PlaceholderSignals,Signal)
    return Signal
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

    --self.Proxy.RegisterProxy("GetChildren", "GetDescendants")

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
        Current.Value = Value

        if not DontUpdate then
            ---@diagnostic disable-next-line: redundant-parameter
            self.Proxy.ConstraintUpdator(self)
        end
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

function Thing:GetPath()
    local String = self.Name

    self:GetParentCallback(function(Parent)
        String = Parent.Name.."."..String
    end)

    return String
end

function Thing:__tostring()
    return "\""..self.Name.."\": "..self.ClassName.." ("..self.UUID..")"
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

function Thing:GetChild(Name) -- THIS IS FOR INTERNAL!!
    for i,v in pairs(self.Children) do
        if v.Name == Name then
            return self.Children[i]
        end
    end
end

function Thing:SetName(Name)
    if self:IsSerializable() then
        Runtime.Things.RequestTreeChange(self)
    end
    
    self.Name = Name
end

-- Get the property or the override for it
-- If you dont want the overriden property, dont use this
function Thing:GetProperty(Property)
    return (self.Overrides[Property] and self.Overrides[Property].Value) or self[Property]
end

function Thing:Destroy()
    Things.Remove(self)
end

--[[function Thing:WaitForChild(Name)
    local Time = 5
    while Time>=0 do   
        Scheduler.Yield(1)
        Time=Time-1
        if self:FindFirstChild(Name) then
            return self.Child[Name]
        end
    end
    assert(Name.." hasnt been found as a "..self.Name.." child.")
end]]

function Thing:Clone(DontCloneChildren)
    local NewThing = Things.New(self.ClassName)

    for Property,Val in pairs(self.Proxy.Accessible) do 
        if self.Proxy.Types[Property] then
            Type = self[Property]
            Things.SetProperty(NewThing,Property,Type)
        end
    end

    if not DontCloneChildren then
        for _, Child in pairs(self:GetChildren()) do
            local NewChild = Child:Clone()
            NewChild:SetParent(NewThing)
        end
    end
    
    return NewThing
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
		if Parent then
            local CallbackResult = Callback(Parent)

            if CallbackResult then
			    return (Utils.TypeOf(CallbackResult) == "Thing") and CallbackResult or Parent
            end
		end
	until (not Parent)
	
	return Parent
end

function Thing:IsSerializable()
    local Serializable = true
    local EncounteredRoot

    ---@param ParentThing Thing
    self:GetParentCallback(function(ParentThing)
        if ParentThing:IsA("Root") then
            EncounteredRoot = true
        end

        if not (ParentThing.Serializable) and not (ParentThing:IsA("Root")) then
            Serializable = false
        end
    end)

    if (not EncounteredRoot) then return end

    -- HACK: This could probably be a part of GetParentCallback, and doesnt need to be hacked in like this.
    -- Return false if object itself isnt serializable
    if (not self.Serializable) then
        return false
    end

    return Serializable
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

--[[
    EXTENDING FROM THIS FUNCTION REQUIRES YOU TO HANDLE THIS SUPERFUNCTION IN A SPECIAL MANNER:
    Example:
        function Object:SetParent(NewParent)
            local CouldParent, Reason = Object.super.SetParent(self, NewParent)

            if CouldParent then 

            end -- Only needed if the following assumes that it could parent

            return CouldParent, Reason
        end   
]]
-- Sets the current parent of a thing
function Thing:SetParent(NewParent)
    local CouldRecurse = self:CheckRecursion(NewParent)

    if CouldRecurse then
        print(CouldRecurse)
        printVerbose(debug.traceback())

        return false, CouldRecurse
    end

    local OldParent = self.Parent

    if OldParent then
        OldParent.ChildrenChanged.Invoke(Enum.Hierachy.Removed, self)
        OldParent.Children[self.UUID] = nil
        table.removeValue(OldParent.InterfaceChildren, self)
    end

    if NewParent then
        NewParent.ChildrenChanged.Invoke(Enum.Hierachy.Added, self)
        NewParent.Children[self.UUID] = self

        if self:IsA("BaseGui") then
            table.insert(NewParent.InterfaceChildren, self)
        end
    else
        self.OrphanedPath = self:GetPath()
    end
    
    local SerializeCheck = NewParent or OldParent

    if SerializeCheck and SerializeCheck:IsSerializable() then
        Runtime.Things.RequestTreeChange(self)
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
    local Type = Things.Type(ObjectType)
    local Result = self:is(Type)

    Type = nil

    return Result
    --return self:is(Things.ClassDump[ObjectType])
end

function Thing:GetChildren()
    return self.Children
end

function Thing:GetInterfaceChildren()
    return self.InterfaceChildren
end

function Thing:OnRemove()
    self.Unreferenced = true

    self.OnDestroy.Invoke(self)
    for _,Signal in pairs(self.PlaceholderSignals) do
        if not Signal.AlreadyDisconnected then
            Signal:Disconnect()
        end
    end
    table.clear(self.PlaceholderSignals)

    self:SetParent()
    self:ClearAllChildren()
end

local function GetDescendantsImpl(Object, ReturnedDescendants)
    for _, Descendant in pairs(Object:GetChildren()) do
        table.insert(ReturnedDescendants, Descendant)
        GetDescendantsImpl(Descendant, ReturnedDescendants)
    end
end


function Thing:GetDescendants()
    local ReturnedDescendants = {}
    
    GetDescendantsImpl(self, ReturnedDescendants)

    return ReturnedDescendants
end

local function GetDescendantsTreeImpl(Object, Table)
    Table[Object.Name] = {}

    for _, Descendant in pairs(Object:GetChildren()) do
        GetDescendantsTreeImpl(Descendant, Table[Object.Name])
    end
end

function Thing:GetDescendantTree()
    local ReturnedDescendants = {}

    GetDescendantsTreeImpl(self, ReturnedDescendants)

    return ReturnedDescendants
end

-- TODO: Also, couldnt we just call DescendantOf on the Descendant to check if the thing is an ancestor?
-- Idk what is this supost to do so im leaving it like this!!
function Thing:AncestorOf(Descendant)
end

function Thing:FindFirstChildOfClass(Class)
    for ChildUUID,_ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)

        if Child:IsA(Class) then
            return Child
        end
    end
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
    if NameFilter and type(NameFilter) == "string" then assert("ClearAllChildren filter needs to be a table of strings") end
    NameFilter = NameFilter or {}

    for ChildUUID, _ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)

        if Child and (not table.find(NameFilter, Child.Name)) then
            Child:Destroy()
        end

        -- Certain objects are stubborn for some reason
        --self.Children[ChildUUID] = nil
        --table.removeValue(self.InterfaceChildren, Child)
    end 
end

function Thing:PostUpdate() end
function Thing:Invalidate() end
function Thing:Update() end

return Thing