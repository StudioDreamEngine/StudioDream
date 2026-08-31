local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class ScrollContainer: Viewport2D
local ScrollContainer = Things.Extend("Viewport2D") -- Also make this get extended form Square!! we need the background stuff sorry

function ScrollContainer:new()
    ScrollContainer.super.new(self)

    self.ScrollTarget, self.ScrollPosition = 0, 0
    self.LastScroll = 0

    self.CanvasSize = Pivot2D.FromScale(1,2)
    self.UseCanvasSize = false -- If or if not to use the canvas size for the scale attribute of pivots

    self.Hovering = false

    self.ForegroundColor = Color.new(1)

    self.CornerRadius = 5
    self.LimitCornerRadius = 0

    self.BarColor = Color.new(1)
    self.BarTransparency = 0
    
    self.WheelMoved = LoveEvents.WheelMoved:Connect(function(_, y)
        if (not self.Hovering) then return end

        self.ScrollTarget = self.ScrollTarget + y*40
    end)

    self:BindConstraint("Scroll", "ChildRect")
end

function ScrollContainer:DefineAPI()
    ScrollContainer.super.DefineAPI(self)

    self.Proxy.Property("Pivot2D CanvasSize","number ScrollPosition","Color BarColor","number BarTransparency")
    self.Proxy.Group("Scroll","CanvasSize","ScrollPosition")
    self.Proxy.Group("Bar","BarColor","BarTransparency")
    self.Proxy.MakeCreatable()
end

function ScrollContainer:SetScroll(Scroll)
    self.ScrollTarget = Scroll
end

-- get the absolute canvas size
function ScrollContainer:GetCanvasSize()
    return self.CanvasSize.Offset + (self.AbsoluteSize * self.CanvasSize.Scale)
end

function ScrollContainer:SetUseCanvasSize(new)
    self.UseCanvasSize = new
    self:UpdateConstraint()
end

function ScrollContainer:UpdateConstraint()
    self:SetConstraint("Scroll", "ChildRect", Rect.new(Vector2.new(0,self.ScrollPosition), (self.UseCanvasSize and self:GetCanvasSize() or self.AbsoluteSize)))
end

function ScrollContainer:Draw()
    ScrollContainer.super.Draw(self)
    
    --[[
        Draw the scrollbar, this little bitch is so fucking stubborn

        Sometimes i wish i never had to write ui code again, but here i am, 
        suffering through like what, the 25th stage of hell?
        
        - Bloctans
    ]]
    local TotalCanvasSize = self:GetCanvasSize() - self.AbsoluteSize.Y

    -- oh god...
    local CanvasScale2 = (self:GetCanvasSize().Y / self.AbsoluteSize.Y)
    local CanvasScale = (TotalCanvasSize.Y / self.AbsoluteSize.Y) -- How large CanvasSize is compared to AbsoluteSize

    local BarPos = (-self.ScrollPosition / CanvasScale)
    local BarSize = self.AbsoluteSize.Y / CanvasScale2
    local BarPivot = BarSize * (BarPos / self.AbsoluteSize.Y)
    
    -- Just calc the radius

    local ActualbarSize = Vector2.new(5,BarSize)

    if self.LimitCornerRadius then
        local Size = (ActualbarSize.X < ActualbarSize.Y) and ActualbarSize.X/2 or ActualbarSize.Y/2
        self.TrueRadiusOfCorners = (self.CornerRadius > Size) and Size or self.CornerRadius
    else 
        self.TrueRadiusOfCorners = self.CornerRadius
    end

    --
    Runtime.Backend2D.SetColor(self.BarColor,1 - self.BarTransparency)
    love.graphics.rectangle("fill", self.AbsoluteSize.X-5, BarPos - BarPivot, 5, BarSize,self.TrueRadiusOfCorners,self.TrueRadiusOfCorners)

end

function ScrollContainer:SetAbsoluteSize(New)
    ScrollContainer.super.SetAbsoluteSize(self, New)
    self:UpdateConstraint()
end

function ScrollContainer:Update(dt)
    ScrollContainer.super.Update(self, dt)

    self.ScrollPosition = math.lerp(self.ScrollPosition, self.ScrollTarget, .4)

    local MaxScroll = self:GetCanvasSize().Y - self.AbsoluteSize.Y

    -- Elastic scroll bounding, because why not
    if self.ScrollTarget < -MaxScroll then
        self.ScrollTarget = self.ScrollTarget + (-MaxScroll - self.ScrollTarget)*dt*12
    elseif self.ScrollTarget > 0 then
        self.ScrollTarget = self.ScrollTarget + (0 - self.ScrollTarget)*dt*12
    end

    local ObjectRect = Rect.new(Vector2.zero, self.AbsoluteSize)

    self.Hovering = self.TruelyVisible and Utils.IntersectPoint2D(ObjectRect, self.MousePosition)

    -- Temporary optimization
    if self.TruelyVisible and math.abs(self.LastScroll - self.ScrollPosition) > 0.1 then
        Profiler.Start("ScrollContainer - Update Constraint")
        self:UpdateConstraint()
        Profiler.End()
    end

    self.LastScroll = self.ScrollPosition
end

return ScrollContainer