local Things = Runtime.Things

---@class ParentConstraint: BaseConstraint
local ParentConstraint = Things.Extend("BaseConstraint")

function ParentConstraint:new()
    ParentConstraint.super.new(self)

    self.ChildrenEvent = nil
end

---@param NewParent Thing
function ParentConstraint:SetParent(NewParent)
    local CouldParent, Reason = ParentConstraint.super.SetParent(self, NewParent)

    if self.ChildrenEvent then self.ChildrenEvent:Disconnect() end -- Cleanup

    -- Parent would be nil, thus we cant connect a new event
    -- (No guard clause here do to return from superfunction)
    if NewParent then 
        -- Check if any object in the parent is added or removed
        self.ChildrenEvent = NewParent.ChildrenChanged:Connect(function(Child, EventType)
            if EventType == Enum.Hierachy.Removed then
                self:UnbindObject(Child)
            else
                self:BindObject(Child)
            end
        end)
    end

    return CouldParent, Reason
end

-- Adds all the children of the parent object to the constraint
function ParentConstraint:Bind()
    for _, Object in pairs(self.Parent:GetChildren()) do
        self:BindObject(Object)
    end
end

return ParentConstraint