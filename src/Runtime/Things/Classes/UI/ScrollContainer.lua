local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class ScrollContainer: Viewport2D
local ScrollContainer = Things.Extend("Viewport2D")

function ScrollContainer:new()
    ScrollContainer.super.new(self)

    self.ScrollTarget, self.ScrollPosition = 0, 0

    self.CanvasSize = Pivot2D.FromScale(1,2)

    self.Hovering = false

    self.WheelMoved = LoveEvents.WheelMoved:Connect(function(_, y)
        if (not self.Hovering) then return end

        self.ScrollTarget = self.ScrollTarget + y*40
    end)

    self:BindConstraint("Scroll", "ChildRect")
end

function ScrollContainer:DefineAPI()
    ScrollContainer.super.DefineAPI(self)

    self.Proxy.MakeCreatable()
end

function ScrollContainer:OnRemove()
    ScrollContainer.super.OnRemove(self)
end

function ScrollContainer:SetScroll(Scroll)
    self.ScrollTarget = Scroll
end

-- get the absolute canvas size
function ScrollContainer:GetCanvasSize()
    return self.CanvasSize.Offset + (self.AbsoluteSize * self.CanvasSize.Scale)
end

function ScrollContainer:Update(dt)
    ScrollContainer.super.Update(self, dt)

    self.ScrollPosition = math.lerp(self.ScrollPosition, self.ScrollTarget, .4)

    local MaxScroll = self:GetCanvasSize().Y

    local ObjectRect = Rect.new(Vector2.zero, self.AbsoluteSize)

    self.Hovering = self:IsVisible() and Utils.IntersectPoint2D(ObjectRect, self.MousePosition)

    -- Elastic scroll bounding, because why not
    if self.ScrollTarget > 0 then
        self.ScrollTarget = self.ScrollTarget + (0 - self.ScrollTarget)*dt*12
    elseif self.ScrollTarget < -MaxScroll then
        self.ScrollTarget = self.ScrollTarget + (-MaxScroll - self.ScrollTarget)*dt*12
    end

    -- Temporary optimization
    if self.TruelyVisible then
        self:SetConstraint("Scroll", "ChildRect", Rect.new(Vector2.new(0,self.ScrollPosition), self.AbsoluteSize))
    end
end

return ScrollContainer