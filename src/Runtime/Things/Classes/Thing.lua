-- Base class for thing
local Things = Runtime.Things
local Thing = Object:extend()

function Thing:New()
    self.Children = {}
    self.Parent = nil 
    self.CanBeRendered = true
    self.UUID = CreateUUID()

    self.Explorer = {
        Visible = true,
        Icon = "shape_square"
    }

    self.Changed = Signal:New("PropertyChange")

    self.Changed:Connect(function(OldParent, NewParent)
        --print("Old Parent:",OldParent.Name, "New Parent:",NewParent.Name)
    end, "Parent")
end

function Thing:SetParent(NewParent)
    self.Parent = NewParent

    NewParent.Children = Utils.UpdateTable(NewParent.Children, self.UUID, true)
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

--[[function Thing:__newindex(index, value)
    if self.Changed then
        self.Changed.Invoke(index, self[index], value)
    end

    return rawset(self, index, value)
end]]

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
    return Thing:is(Things.Type(ObjectType))
end

function Thing:GetChildren()
    local ReturnedChildren = {}

    for ChildUUID, _ in pairs(self.Children) do
        table.insert(ReturnedChildren, Things.Get(ChildUUID))
    end

    return ReturnedChildren
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
    for ChildUUID,_ in pairs(self.Children) do
        local Child = Things.Get(ChildUUID)
        if not NameFilter[Child.Name] then
            Things.Remove(Child)
        end
    end 
end



function Thing:Update()
end

return Thing