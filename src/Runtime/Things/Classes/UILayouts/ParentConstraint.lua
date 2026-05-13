local Things = Runtime.Things

---@class ParentConstraint: BaseConstraint
local ParentConstraint = Things.Extend("BaseConstraint")

function ParentConstraint:new()
    ParentConstraint.super.new(self)

    self.ChildrenEvent = nil
end

---@param NewParent Thing
function ParentConstraint:SetParent(NewParent)
    ParentConstraint.super.SetParent(self, NewParent)

    if self.ChildrenEvent then self.ChildrenEvent:Disconnect() end
    if (not NewParent) then return end
    
    self.ChildrenEvent = NewParent.ChildrenChanged:Connect(function(Child, EventType)
        if EventType == Enum.Hierachy.Removed then
            self:UnbindObject(Child)
        else
            self:BindObject(Child)
        end
    end)
end

function ParentConstraint:Bind()
    for _, Object in pairs(self.Parent:GetChildren()) do
        self:BindObject(Object)
    end
end

return ParentConstraint