local Things = Runtime.Things

---@class DragPoint: Square
local DragPoint = Things.Extend("Square")

function DragPoint:new()
    DragPoint.super.new(self)

    self.StartHolding = Signal:New("StartHolding")
    self.EndHolding = Signal:New("EndHolding")
    self.ChangedPercentage = Signal:New("ChangedPercentage")

    self.Hovering = false

    self.Holding = false
    self.Collidable = true
    self.Percentage = Vector2.zero

    self.Active = true
   -- self.Pivot = Vector2.new(0.5,0.5)
   -- self.Position = Pivot2D.FromScale(0,0.5)
end

function DragPoint:DefineAPI()
    DragPoint.super.DefineAPI(self)

    self.Proxy.Property("number Percentage")
    self.Proxy.Group("Slider","Percentage")
    self.Proxy.Icon("Slider")

    --self.Proxy.MakeCreatable()
end

function DragPoint:OnInitalParent(NewParent)
    DragPoint.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)

    Runtime.InterfaceManager.OnClickPress:Connect(function()
        if not self.Hovering then return end
        if not self.Active then return end
        self.Holding = true
        self.StartHolding.Invoke()
    end)

    Runtime.InterfaceManager.OnRelease:Connect(function()
        if not self.Active then return end
        self.Holding = false
        self.EndHolding.Invoke()
    end)
end

function DragPoint:OnRemove()
    DragPoint.super.OnRemove(self)

    self.Hovering = false
    self.StartHolding:DisconnectAll()
    self.EndHolding:DisconnectAll()
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function DragPoint:SetPercentage(NewNumber)
    local Percentage = math.clamp(NewNumber, 0, 1)
    local Old = self.Percentage

    self.Percentage = Percentage

    if Old ~= Percentage then
        self.ChangedPercentage.Invoke(Percentage)
    end

    if self.Parent and self.Parent:IsA("BaseGui") then
        local EdgePosition = self.Parent.AbsolutePosition - (self.Parent.AbsoluteSize * self.Parent.Pivot) -- 0
        local SidePosition = self.Parent.AbsolutePosition + (self.Parent.AbsoluteSize * self.Parent.Pivot) -- 1
        
        local PositionConverted = EdgePosition:Lerp(SidePosition, Percentage)
        self:HandleDrag(PositionConverted)
    end
end

function DragPoint:HandleDrag(Position) -- Omg this was stressing, sometimes i didnt even know what i was doing, anyway, last thing im gonna do on release is make this only use absolute stuff
    local MousePos = Position

    local EdgePosition = self.Parent.AbsolutePosition - (self.Parent.AbsoluteSize * self.Parent.Pivot)
    local SidePosition = MousePos - EdgePosition
    local PercentageX = math.clamp(SidePosition.X / self.Parent.AbsoluteSize.X, 0, 1)
    local PercentageY = math.clamp(SidePosition.Y / self.Parent.AbsoluteSize.Y, 0, 1)
    local Old = self.Percentage

    self.Percentage = Vector2.new(PercentageX,PercentageY)

    if Old ~= Percentage then
        self.ChangedPercentage.Invoke(Percentage)
    end

    
    self:SetPosition(Pivot2D.FromScale(PercentageX,PercentageY))
    if self.Collidable then
        self:SetPivot(Vector2.new(PercentageX,PercentageY))
    end
end

function DragPoint:Update(dt)
    DragPoint.super.Update(dt,self)

    if self.Holding and self.Parent and self.Parent:IsA("BaseGui") then
        self:HandleDrag(Runtime.Backend2D.GetMousePosition())
    end
end

return DragPoint