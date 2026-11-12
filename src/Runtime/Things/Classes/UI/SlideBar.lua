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
    self.AdjustYAxis = true

    self.CanMove = true

    self.SlideAxis = Enum.SlideAxis.X

    self.Active = true
   -- self.Pivot = Vector2.new(0.5,0.5)
   -- self.Position = Pivot2D.FromScale(0,0.5)
end

function SlideBar:DefineAPI()
    SlideBar.super.DefineAPI(self)

    self.Proxy.Property("boolean AdjustYAxis")
    self.Proxy.Property("number Percentage","boolean Collidable","Enum.SlideAxis SlideAxis","boolean CanMove")
    self.Proxy.Group("Slider","Percentage","Collidable","SlideAxis","AdjustYAxis","CanMove")
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
        self.StartHolding:Invoke()
    end)

    Runtime.InterfaceManager.OnRelease:Connect(function()
        if not self.Active then return end
        self.Holding = false
        self.EndHolding:Invoke()
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
    local Old = self.Percentage

    self.Percentage = Percentage

    if Old ~= Percentage then
        self.ChangedPercentage:Invoke(Percentage)
    end

    if self.Parent and self.Parent:IsA("BaseGui") then
        local EdgePosition=self.Parent.AbsolutePosition - (self.Parent.AbsoluteSize * self.Parent.Pivot) -- 0
        local SidePosition = self.Parent.AbsolutePosition + (self.Parent.AbsoluteSize * self.Parent.Pivot) -- 1

        if self.SlideAxis == "Y" and self.AdjustYAxis then
            Percentage = Percentage + 0.26
        end

        local PositionConverted = EdgePosition:Lerp(SidePosition, Percentage)
        self:HandleDrag(PositionConverted)
    end
end

function SlideBar:HandleDrag(Position) -- Omg this was stressing, sometimes i didnt even know what i was doing, anyway, last thing im gonna do on release is make this only use absolute stuff
    local MousePos = Position[self.SlideAxis]

    local EdgePosition
    if self.SlideAxis == "X" then
        EdgePosition = self.Parent.AbsolutePosition[self.SlideAxis] - (self.Parent.AbsoluteSize[self.SlideAxis] * self.Parent.Pivot[self.SlideAxis])
    elseif not self.AdjustYAxis then
        EdgePosition = self.Parent.AbsolutePosition[self.SlideAxis] - (self.Parent.AbsoluteSize[self.SlideAxis] * self.Parent.Pivot[self.SlideAxis])
    elseif self.SlideAxis == "Y" then 
        EdgePosition = self.Parent.AbsolutePosition[self.SlideAxis] - (self.Parent.AbsoluteSize[self.SlideAxis] * (0.74-self.Parent.Pivot[self.SlideAxis]))
    end
    local SidePosition = MousePos - EdgePosition
    local Percentage = math.clamp(SidePosition / self.Parent.AbsoluteSize[self.SlideAxis], 0, 1)
    local Old = self.Percentage

    printVerbose(MousePos,EdgePosition,SidePosition)

    self.Percentage = Percentage

    if Old ~= Percentage then
        self.ChangedPercentage:Invoke(Percentage)
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

    if self.Holding and self.Parent and self.Parent:IsA("BaseGui") and self.CanMove then
        self:HandleDrag(Runtime.Backend2D.GetMousePosition())
    end
end

return SlideBar