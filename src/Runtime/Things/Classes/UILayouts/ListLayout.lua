local Things = Runtime.Things

---@class ListLayout: ParentConstraint
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"}
    self.ObjectFilter = "BaseGui"

    self.Direction = Enum.LayoutDirection.Vertical
    self.Alignment = Enum.AlignmentX.Left

    self.Padding = 0

    self.RemainingSize = 0

    self.Proxy.Property("Direction", "Padding")
end

function ListLayout:Update()
    ListLayout.super.Update(self)

    local Vertical = (self.Direction == Enum.LayoutDirection.Vertical)

    local Axis = Vertical and "Y" or "X"
    local OpposingAxis = Vertical and "X" or "Y"
    local AxisVector = Vector2[Vertical and "yAxis" or "xAxis"]
    local OpposingVector = Vector2[Vertical and "xAxis" or "yAxis"]

    local TotalSpace = self.Parent.AbsoluteSize[Axis]
    local OpposingSpace = self.Parent.AbsoluteSize[OpposingAxis]

    local ContentSize = 0
    local Positions = {}

    table.sort(self.Objects, function(a, b)
        return (a.ListOrder < b.ListOrder)
    end)

    for _, Object in pairs(self.Objects) do
        Positions[Object.UUID] = ContentSize
        
        ContentSize = ContentSize + Object.AbsoluteSize[Axis] + self.Padding
    end

    ---@param Object BaseGui
    for _, Object in pairs(self.Objects) do
        local Position = Positions[Object.UUID]

        if self.Alignment == Enum.AlignmentX.Center then
            Position = Position + (-ContentSize + TotalSpace)/2
        end

        self:SetConstraint(Object, "Position", Pivot2D.FromOffset(
            (Position * AxisVector) - ((-OpposingSpace + Object.AbsoluteSize)/2 * OpposingVector)
        ))
    end

    self.RemainingSize = TotalSpace - (ContentSize - self.Padding)
end

return ListLayout