local Things = Runtime.Things

---@class ListLayout: ParentConstraint
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"} -- These are the properties that will be controled by the object
    self.ObjectFilter = "BaseGui" -- These are the objects that can be binded, if an object that isnt this is passed into BindObject, its ignored

    self.Direction = Enum.LayoutDirection.Vertical
    self.Alignment = Enum.AlignmentX.Left

    self.Padding = 0

    self.RemainingSize = 0

    self.Proxy.Property("Enum Direction", "number Padding")
end

function ListLayout:Update()
    ListLayout.super.Update(self)

    local Vertical = (self.Direction == Enum.LayoutDirection.Vertical)

    -- Define the axises we will be using in order to calculate stuff
    local Axis = Vertical and "Y" or "X"
    local OpposingAxis = Vertical and "X" or "Y"
    local AxisVector = Vector2[Vertical and "yAxis" or "xAxis"]
    local OpposingVector = Vector2[Vertical and "xAxis" or "yAxis"]

    local TotalSpace = self.Parent.AbsoluteSize[Axis]
    local OpposingSpace = self.Parent.AbsoluteSize[OpposingAxis]

    local ContentSize = 0
    local Positions = {}

    -- Sort the objects so they appear how they are supposed to
    table.sort(self.Objects, function(a, b)
        return (a.ListOrder < b.ListOrder) or (a.NumericalID < b.NumericalID)
    end)

    -- Pass 1: Handle the inital layout of the objects
    for _, Object in pairs(self.Objects) do
        if Object.Visible then
            Positions[Object.UUID] = ContentSize
            ContentSize = ContentSize + Object.AbsoluteSize[Axis] + self.Padding
        end
    end

    -- Pass 2: Handle the positioning and alignment of all objects
    ---@param Object BaseGui
    for _, Object in pairs(self.Objects) do
        if Object.Visible then
            local Position = Positions[Object.UUID]

            if self.Alignment == Enum.AlignmentX.Center then
                Position = Position + (-ContentSize + TotalSpace)/2
            end

            self:SetConstraint(Object, "Position", Pivot2D.FromOffset(
                (Position * AxisVector) - ((-OpposingSpace + Object.AbsoluteSize)/2 * OpposingVector)
            ))
        end
    end

    self.RemainingSize = TotalSpace - (ContentSize - self.Padding)
end

return ListLayout