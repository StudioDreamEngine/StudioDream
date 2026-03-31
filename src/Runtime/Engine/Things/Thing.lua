-- Base class for thing
local Things = Runtime.Engine.Things

return { new = function()
    local Thing = {}

    -- For now we can keep this public, however we should have some kind of visiblity system, perhaps within the code that handles the scripting side
    Thing.Children = {}
    Thing.Properties = {}
    Thing.Parent = nil

    function Thing.DescendantOf(Ancestor) -- Thinking if Ancestor is a thing but this should be editted in the future tho
       return table.find(Ancestor.Children,Thing) 
    end

    function Thing.GetDescendants()
         local ReturnedDescendant = {}

        local function GetChildOf(ThingTo)
            for ChildUUID, _ in ThingTo.Children do
                local Child = Things.Get(ChildUUID) -- dont forget this is a thing!!#@!@
                table.insert(ReturnedDescendant, Child)
                if ThingTo.Children then
                    GetChildOf(ThingTo)
                end
            end
        end
        
        GetChildOf(Thing)

        return ReturnedDescendant
    end

    function Thing.GetChildren()
        local ReturnedChildren = {}

        for ChildUUID, _ in Thing.Children do
            local Child = Things.Get(ChildUUID)
            table.insert(ReturnedChildren, Child)
        end

        return ReturnedChildren
    end

    -- The properties could be only the name of the current properties on the thing, and could be storage in an other file but idk!
    function Thing.GetProperties()

    end
    
    -- TODO: Also, couldnt we just call DescendantOf on the Descendant to check if the thing is an ancestor?
    -- Idk what is this supost to do so im leaving it like this!!
    function Thing.AncestorOf(Descendant)
        
    end

    function Thing.FindFirstChild(Name)
        for ChildUUID,_ in Thing.Children do
            local Child = Things.Get(ChildUUID)
            return Child.Name == Name and Child or nil
            end
        end
        return 
    end

    function Thing.ClearAllChildren(NameFilter:table)
        for ChildUUID,_ in Thing.Children do
            local Child = Things.Get(ChildUUID)
            if not NameFilter[Child.Name] then
                Things.Remove(Child)
                ChildUUID = nil
            end
        end 
    end


    return Thing
    
    -- We will move this to the lua api itself
    --[[setmetatable(Thing, {
        __index = function (Table, Key)
            local Value = rawget(Table, Key)

            if (not Value) then
                return Things.GetThing(Thing.Children[Key]) -- Assume indexing child
            else
                return Value
            end
        end
    })]]
end }