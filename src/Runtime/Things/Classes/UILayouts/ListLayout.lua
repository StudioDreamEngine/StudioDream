local Things = Runtime.Things

---@class ListLayout: ParentConstraint
local ListLayout = Things.Extend("ParentConstraint")

function ListLayout:new()
    ListLayout.super.new(self)

    self.ConstraintProperties = {"Position"} -- These are the properties that will be controled by the object
    self.ObjectFilter = "BaseGui" -- These are the objects that can be binded, if an object that isnt this is passed into BindObject, its ignored

    self.Direction = Enum.LayoutDirection.Vertical
    self.Alignment = Vector2.zero

    self.Padding = 0

    self.RemainingSize = 0
    self.ShouldUpdate = false
    
    self.OnChangedEvents = {}
end

function ListLayout:BindObject(_child)
    ListLayout.super.BindObject(self, _child)
    --print(_child.Name, "binded to", self.Name)
    self:UpdateLayout()

    self.OnChangedEvents[_child] = _child.PropertyChanged:Connect(function(Value, Key)
        if Key == "AbsoluteSize" then
            print("wow")
            self:RequestUpdateLayout()
        end
    end)
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

    self.Proxy.Property("Enum Direction", "number Padding")
    self.Proxy.MakeCreatable()
end

function ListLayout:Update()
    ListLayout.super.Update(self)

    if self.ShouldUpdate then
        self:UpdateLayout()
        self.ShouldUpdate = false
    end
end

function ListLayout:RequestUpdateLayout()
    self.ShouldUpdate = true
end

function ListLayout:UpdateLayout()
    local Vertical = (self.Direction == Enum.LayoutDirection.Vertical)

    -- Define the axises we will be using in order to calculate stuff
    local Axis = Vertical and "Y" or "X"
    local AxisVector = Vector2[Vertical and "yAxis" or "xAxis"]
    local OpposingVector = Vector2[Vertical and "xAxis" or "yAxis"]

    local ParentSize = self.Parent:GetRect().Size

    local TotalSpace = ParentSize[Axis]

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

            local BoundsSize = (Object.AbsoluteSize * OpposingVector) + (ContentSize * AxisVector)

            self:SetConstraint(Object, "Position", Pivot2D.FromOffset(
                (Position * AxisVector) + Utils.GetAlignment(self.Alignment, ParentSize, BoundsSize)
            ))
        end
    end

    self.RemainingSize = TotalSpace - (ContentSize - self.Padding)
end

return ListLayout