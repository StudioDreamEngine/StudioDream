-- Base class for things
local Things = Runtime.Things

---@class Thing
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
    
    self.Proxy = Runtime.ObjectProxy.new()

    self.Children = {}
    self.Parent = nil 
    self.UUID = CreateUUID()

    self.Explorer = {
        Visible = true,
        Icon = "shape_square"
    }

    self.Proxy.Property("Parent")
    self.Proxy.PropertyAccess("UUID")
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

local function CheckSerializable(self)
    local Serializable = true

    ---@param ParentThing Thing
    self:GetParentCallback(function(ParentThing)
        if not (ParentThing.Serializable) and not (ParentThing:IsA("Root")) then
            Serializable = false
        end
    end)

    return Serializable
end

function Thing:IsSerializable()
    return self.TruelySerializable
end

function Thing:SetParent(NewParent)
    if NewParent == self then
        error("Cannot parent Thing to itself.")
    end

    local OldParent = self.parent

    if self.Parent then
        self.Parent.Children[self.UUID] = nil
    end

    if NewParent then
        self.Parent = NewParent
        NewParent.Children[self.UUID] = true
    end

    self.TruelySerializable = CheckSerializable(self)

    if self.TruelySerializable then -- Dont call for now
        --print("Fire HierachyChanged")
        --Things.HierachyChanged:Invoke(self, OldParent, NewParent)
    end
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
    local ReturnedChildren = {}

    for ChildUUID, _ in pairs(self.Children) do
        table.insert(ReturnedChildren, Things.Get(ChildUUID))
    end

    return ReturnedChildren
end

function Thing:OnRemove()
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
        if not NameFilter[Child.Name] then
            Things.Remove(Child)
        end
    end 

    self.Children = {}
end

function Thing:Update() end

return Thing