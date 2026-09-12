local Things = Runtime.Things

---@class SlideBar: Square
local SlideBar = Things.Extend("Square")

function SlideBar:new()
    SlideBar.super.new(self)

    self.StartHolding = Signal:New("StartHolding")
    self.EndHolding = Signal:New("EndHolding")
    self.ChangedPercentage = Signal:New("ChangedPercentage")

    self.Hovering = false

    self.Holding = false
    self.Collidable = true
    self.Percentage = 0

    self.SlideAxis = Enum.SlideAxis.X

    self.Active = true
   -- self.Pivot = Vector2.new(0.5,0.5)
   -- self.Position = Pivot2D.FromScale(0,0.5)
end

function SlideBar:DefineAPI()
    SlideBar.super.DefineAPI(self)

    self.Proxy.Property("number Percentage")
    self.Proxy.Group("Slider","Percentage")
    self.Proxy.Icon("Slider")

    self.Proxy.MakeCreatable()
end

function SlideBar:OnInitalParent(NewParent)
    SlideBar.super.OnInitalParent(self, NewParent)
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

function SlideBar:OnRemove()
    SlideBar.super.OnRemove(self)

    self.Hovering = false
    self.StartHolding:DisconnectAll()
    self.EndHolding:DisconnectAll()
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function SlideBar:SetPercentage(NewNumber)
    local Percentage = math.clamp(NewNumber, 0, 1)

    self.Percentage = Percentage

    if self.Percentage~=Percentage then
        self.ChangedPercentage.Invoke(Percentage)
    end

    if self.Parent and self.Parent:IsA("BaseGui") then
        local EdgePosition = self.Parent.AbsolutePosition - (self.Parent.AbsoluteSize * self.Parent.Pivot) -- 0
        local SidePosition = self.Parent.AbsolutePosition + (self.Parent.AbsoluteSize * self.Parent.Pivot) -- 1
        
        local PositionConverted = EdgePosition:Lerp(SidePosition, Percentage)
        self:HandleDrag(PositionConverted)
    end
end

function SlideBar:HandleDrag(Position) -- Omg this was stressing, sometimes i didnt even know what i was doing, anyway, last thing im gonna do on release is make this only use absolute stuff
    local MousePos = Position[self.SlideAxis]

    local EdgePosition = self.Parent.AbsolutePosition[self.SlideAxis] - (self.Parent.AbsoluteSize[self.SlideAxis] * self.Parent.Pivot[self.SlideAxis])
    local SidePosition = MousePos - EdgePosition
    local Percentage = math.clamp(SidePosition / self.Parent.AbsoluteSize[self.SlideAxis], 0, 1)

    self.Percentage = Percentage

    if self.Percentage~=Percentage then
        self.ChangedPercentage.Invoke(Percentage)
    end

    if self.SlideAxis == "X" then
        self:SetPosition(Pivot2D.FromScale(Percentage,self.Position.Scale.Y))
        if self.Collidable then
            self:SetPivot(Vector2.new(Percentage,self.Pivot.Y))
        end
    else
        self:SetPosition(Pivot2D.FromScale(self.Position.Scale.X,Percentage))
        if self.Collidable then
            self:SetPivot(Vector2.new(self.Pivot.X,Percentage))
        end
    end
end

function SlideBar:Update(dt)
    SlideBar.super.Update(dt,self)

    if self.Holding and self.Parent and self.Parent:IsA("BaseGui") then
        self:HandleDrag(Runtime.Backend2D.GetMousePosition())
    end
end

return SlideBar