-- Base class for thing
local Things = Runtime.Engine.Things

return { new = function()
    local Thing = {}

    -- For now we can keep this public, however we should have some kind of visiblity system, perhaps within the code that handles the scripting side
    Thing.Children = {}
    Thing.Parent = nil

    function Thing.DescendantOf(Ancestor)
        
    end

    -- TODO: Also, couldnt we just call DescendantOf on the Descendant to check if the thing is an ancestor?
    function Thing.AncestorOf(Descendant)
        
    end

    function Thing.GetChildren()
        local ReturnedChildren = {}

        for ChildUUID, _ in Thing.Children do
            local Child = Things.Get(ChildUUID)
            table.insert(ReturnedChildren, Child)
        end

        return ReturnedChildren
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