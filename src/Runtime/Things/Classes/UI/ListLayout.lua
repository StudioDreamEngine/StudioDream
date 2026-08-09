local Things = Runtime.Things

---@class ListLayout: ParentConstraint
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"} -- These are the properties that will be controled by the object
    self.ObjectFilter = "BaseGui" -- These are the objects that can be binded, if an object that isnt this is passed into BindObject, its ignored
    self.ParentFilter = "BaseGui"

    self.Direction = Enum.LayoutDirection.Vertical
    self.Alignment = Vector2.zero

    self.Reverse = false
    self.Padding = 0

    self.SortMode = Enum.SortMode.Alphabetical

    self.RemainingSize = 0
    self.ShouldUpdate = false
    
    self.OnChangedEvents = {}
end

--[[
    ListLayout issue:
        From what i can tell, the delay on updating listlayouts occurs because of propagated changes

        What happens is that propogated changes are usually called AFTER the list layout is updated, meaning that its updated again
]]

function ListLayout:BindObject(_child)
    local Binded = ListLayout.super.BindObject(self, _child)
    if (not Binded) then return end
    --print(_child.Name, "binded to", self.Name)
    self:UpdateLayout()

    if _child:IsA("BaseGui") then
        self.OnChangedEvents[_child] = _child.PropagatedChange:Connect(function(Value, Key)
            self:RequestUpdateLayout()
        end)
    end
end

function ListLayout:UnbindObject(_child)
    ListLayout.super.UnbindObject(self, _child)
    
    if self.OnChangedEvents[_child] ~= nil then
        self.OnChangedEvents[_child]:Disconnect()
        self.OnChangedEvents[_child] = nil
    end
end

function ListLayout:DefineAPI()
    ListLayout.super.DefineAPI(self)

    self.Proxy.Icon("ListLayout")
    self.Proxy.Property("Enum.LayoutDirection Direction", "number Padding", "Enum.Alignment Alignment", "Enum.SortMode SortMode")
    self.Proxy.Group("Layout","Direction","Padding","Alignment","SortMode")

    self.Proxy.Attribute("SortMode", "RequiresEnum")
    self.Proxy.MakeCreatable()
end

function ListLayout:PostUpdate()
    ListLayout.super.PostUpdate(self)

    if self.ShouldUpdate then
        self:UpdateLayout()
        self.ShouldUpdate = false
    end
end

function ListLayout:SetSortMode(NewMode)
    self.SortMode = NewMode
    self:RequestUpdateLayout()
end

function ListLayout:RequestUpdateLayout()
    self.ShouldUpdate = true
end

function ListLayout:SortFunction(a,b,Index)
    local aIndex = a[Index]
    local bIndex = b[Index]

    if self.Reverse then
        return (aIndex == bIndex) and (a.NumericalID > b.NumericalID) or (aIndex > bIndex)
    else
        return (aIndex == bIndex) and (a.NumericalID < b.NumericalID) or (aIndex < bIndex)
    end
end

function ListLayout:UpdateLayout()
    local Vertical = (self.Direction == Enum.LayoutDirection.Vertical)

    -- Define the axises we will be using in order to calculate stuff
    local Axis = Vertical and "Y" or "X"
    local AxisVector = Vector2[Vertical and "yAxis" or "xAxis"]
    local OpposingVector = Vector2[Vertical and "xAxis" or "yAxis"]

    local ParentSize = self.Parent:GetChildRect().Size

    local TotalSpace = ParentSize[Axis]

    local ContentSize = 0
    local Positions = {}

    -- Sort the objects so they appear how they are supposed to
    if self.SortMode == Enum.SortMode.Order then
        ---@param a BaseGui
        ---@param b BaseGui
        table.sort(self.Objects, function(a,b)
            return self:SortFunction(a,b,"ListOrder")
        end)
    elseif self.SortMode == Enum.SortMode.Alphabetical then
        ---@param a BaseGui
        ---@param b BaseGui
        table.sort(self.Objects, function(a,b)
            return self:SortFunction(a,b,"Name")
        end)
    --[[elseif self.SortMode == Enum.SortMode.Numerical then
        table.sort(self.Objects, function(a,b)
            return self:SortFunction(a,b,"Name")
        end)]]
    end

    -- Pass 1: Handle the inital layout of the objects
    local Index = 0
    for _, Object in pairs(self.Objects) do
        if Object.Visible then
            Index=Index+1
            Positions[Object.UUID] = ContentSize
            ContentSize = ContentSize + Object.AbsoluteSize[Axis] + self.Padding
            Object.LayoutOrder = Index
        end
    end

    -- Pass 2: Handle the positioning and alignment of all objects
    ---@param Object BaseGui
    for _, Object in pairs(self.Objects) do
        if Object.Visible then
            local Position = Positions[Object.UUID]

            local BoundsSize = (Object.AbsoluteSize * OpposingVector) + (ContentSize * AxisVector)

            self:SetConstraint(Object, "Position", Pivot2D.FromOffset(
                (Position * AxisVector) + Utils.GetAlignment(self.Alignment, ParentSize, BoundsSize)
            ))
        end
    end

    self.RemainingSize = TotalSpace - (ContentSize - self.Padding)
end

return ListLayout