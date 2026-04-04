-- Base class for thing
local Things = Runtime.Things
local Thing = Object:extend()

function Thing:new()
    self.Children = {}
    self.Parent = nil 
end

function Thing:GetParentCallback(Callback)
	local Parent = self
	
	repeat
		-- We need to also be able to use the callback on the object iself
		if Callback(Parent) then
			break
		end
		
		Parent = Parent.Parent
	until (not Parent)
	
	return Parent
end

function Thing:DescendantOf()
    local ReturnedDescendant = {}

    -- We should improve this, maybe getchildren with a callback>?
    local function GetChildOf(ThingTo)
        for ChildUUID, _ in ThingTo.Children do
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

    for ChildUUID, _ in self.Children do
        table.insert(ReturnedChildren, Things.Get(ChildUUID))
    end

    return ReturnedChildren
end

-- TODO: Also, couldnt we just call DescendantOf on the Descendant to check if the thing is an ancestor?
-- Idk what is this supost to do so im leaving it like this!!
function Thing:AncestorOf(Descendant)
    
end

function Thing:FindFirstChild(Name)
    for ChildUUID,_ in self.Children do
        local Child = Things.Get(ChildUUID)

        if Child.Name == Name then
            return Child
        end
    end
end

function Thing:ClearAllChildren(NameFilter)
    for ChildUUID,_ in self.Children do
        local Child = Things.Get(ChildUUID)
        if not NameFilter[Child.Name] then
            Things.Remove(Child)
        end
    end 
end

return Thing