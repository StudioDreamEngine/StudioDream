local Things = Runtime.Things

-- Someth simillar to css flex ig
-- For now, a flex object simply inherits the rest of the list layouts size

---@class FlexItem: ChildConstraint
local FlexItem = Things.Extend("ChildConstraint")

function FlexItem:new()
    FlexItem.super.new(self)

    self.ConstraintProperties = {"Size"}
    self.ObjectFilter = "BaseGui"

    self.Connection = nil
    self.Connection2 = nil
    self.Connection3 = nil
end

function FlexItem:GetListLayout()
    return self.Parent:FindConstraintOfType("ListLayout")
end

-- Update the actual target
function FlexItem:UpdateFlex()
    ---@diagnostic disable-next-line: assign-type-mismatch
    local Target = self.Parent ---@type BaseGui

    local ListLayout = self:GetListLayout()
    if (not ListLayout) then return end

    ListLayout:RequestUpdateLayout()
    Target:SetConstraint(self, "Size", ListLayout.RemainingSize)
end

-- Handles receiving updates from the parent of the target, as we need to know those, not the targets updates
function FlexItem:BindFlexParent()
    ---@class Thing
    local FlexParent = Object.Parent

    if FlexParent and FlexParent:IsA("BaseGui") then
        self.Connection = FlexParent.PropagatedChange:Connect(function(Value, Key)
            self:UpdateFlex()
        end)

        self.Connection2 = FlexParent.ChildrenChanged:ConnectDeferred(function(Child, EventType)
            if EventType == Enum.Hierachy.Added and Child:IsA("ListLayout") then
                self:UpdateFlex()
            end
        end)
    else
        printVerbose("Could not bind FlexParent for "..self:GetPath())
    end
end

function FlexItem:UnbindFlexParent()
    if self.Connection then self.Connection:Disconnect() end
    if self.Connection2 then self.Connection2:Disconnect() end
    if self.Connection3 then self.Connection3:Disconnect() end
end

function FlexItem:OnRemove()
    FlexItem.super.OnRemove(self)
    self:UnbindFlexParent()
end

-- BindObject is called when a object is added to the constraint
---@param Object Thing
function FlexItem:BindObject(Object)
    local Binded = FlexItem.super.BindObject(self, Object)
    if (not Binded) then return end

    self.Connection3 = Object.ParentChanged:Connect(function()
        self:UnbindFlexParent()
        self:BindFlexParent()
    end)

    self:BindFlexParent()
end

return FlexItem