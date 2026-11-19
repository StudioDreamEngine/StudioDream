local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the Override system
---@class ScrollContainer: ViewportLite
local ScrollContainer = Things.Extend("ViewportLite") -- Also make this get extended form Square!! we need the background stuff sorry

function ScrollContainer:new()
    ScrollContainer.super.new(self)

    self.ScrollTarget, self.ScrollPosition = 0, 0
    self.LastScroll = 0

    self.CanvasSize = Pivot2D.FromScale(1,2)
    self.UseCanvasSize = false -- If or if not to use the canvas size for the scale attribute of pivots

    self.Hovering = false
    self.ForegroundColor = Color.new(1)

    self.BarColor = Color.new(1)
    self.BarTransparency = 0
    self.BarWidth = 5

    self.PresentOnVisible = false

    self.LinkedSlidebar = nil

    self.VisibilityEvent = self.PropagatedChange:Connect(function(IsVisible)
        if IsVisible and self.PresentOnVisible then
            self:Present()
        end
    end, "Visible")
    
    self.WheelMoved = LoveEvents.WheelMoved:Connect(function(_, y)
        if (not self.Hovering) then return end

        self.ScrollTarget = self.ScrollTarget + y*40
    end)

    self.PostEvent = self.PostTransform:Connect(function()
        self:SetOverride("Scroll", "ChildRect", self:GetScrollRect(), true)
    end)

    self:BindOverride("Scroll", "ChildRect")
end

function ScrollContainer:DefineAPI()
    ScrollContainer.super.DefineAPI(self)

    self.Proxy.SetCategory("Containers")

    self.Proxy.Property("Pivot2D CanvasSize","number ScrollPosition","Color BarColor","number BarTransparency","number BarWidth")
    self.Proxy.Group("Scroll","CanvasSize","ScrollPosition")
    self.Proxy.Group("Bar (Builtin)","BarColor","BarTransparency","BarWidth")

    self.Proxy.Icon("ScrollContainer")

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
    self:UpdateOverride()
end

function ScrollContainer:GetScrollRect()
    return Rect.new(Vector2.new(0,self.ScrollPosition), (self.UseCanvasSize and self:GetCanvasSize() or self.AbsoluteSize))
end

function ScrollContainer:UpdateOverride()
    self:ProcessInvalidation()
end

--[[
    Helper function to provide a visual queue for when a scrolling container is "presented".

    Can be called on visibility with ScrollContainer.PresentOnVisible
]]
function ScrollContainer:Present()
    self.ScrollPosition = -200
    self:SetScroll(0)
end

function ScrollContainer:OnRemove()
    ScrollContainer.super.OnRemove(self)

    self.WheelMoved:Disconnect()
    self.VisibilityEvent:Disconnect()
    self.PostEvent:Disconnect()
end

function ScrollContainer:Draw()
    ScrollContainer.super.Draw(self)
    
    --[[
        Draw the scrollbar, this little bitch is so fucking stubborn

        Sometimes i wish i never had to write ui code again, but here i am, 
        suffering through like what, the 25th stage of hell?
        
        - Bloctans
    ]]
    
    if (not self.LinkedSlidebar) then
        local TotalCanvasSize = self:GetCanvasSize() - self.AbsoluteSize.Y

        -- oh god...
        local CanvasScale2 = (self:GetCanvasSize().Y / self.AbsoluteSize.Y)
        local CanvasScale = (TotalCanvasSize.Y / self.AbsoluteSize.Y) -- How large CanvasSize is compared to AbsoluteSize

        local BarPos = (-self.ScrollPosition / CanvasScale)
        local BarSize = self.AbsoluteSize.Y / CanvasScale2
        local BarPivot = BarSize * (BarPos / self.AbsoluteSize.Y)
        
        Runtime.Backend2D.SetColor(self.BarColor,1 - self.BarTransparency)
        love.graphics.rectangle("fill", self.AbsoluteSize.X-self.BarWidth, BarPos - BarPivot, self.BarWidth, BarSize,self.BarWidth/2,self.BarWidth/2)
    end
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
        Profiler.Start("ScrollContainer - Update Override")
        self:UpdateOverride()
        Profiler.End()
    end

    self.LastScroll = self.ScrollPosition
end

return ScrollContainer