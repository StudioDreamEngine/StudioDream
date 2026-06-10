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
        self.ScrollTarget = self.ScrollTarget + y*40
    end)

    self:BindConstraint("Scroll", "ChildRect")
end

function ScrollContainer:OnRemove()
    ScrollContainer.super.OnRemove(self)
end

-- get the absolute canvas size
function ScrollContainer:GetCanvasSize()
    return self.CanvasSize.Offset + (self.AbsoluteSize * self.CanvasSize.Scale)
end

function ScrollContainer:Update(dt)
    ScrollContainer.super.Update(self, dt)

    --if self.Hovering then
        self.ScrollPosition = math.lerp(self.ScrollPosition, self.ScrollTarget, .4)
    --end
    local MaxScroll = self:GetCanvasSize().Y

    local ObjectRect = self:GetRect()
    local DisplayUI = self:GetDisplayUI()

    if (not DisplayUI) then return end

    --self.Hovering = self:IsVisible() and Utils.IntersectPoint2D(ObjectRect, DisplayUI.MousePosition)
    --print(self.Hovering)
    -- Elastic scroll bounding, because why not
    if self.ScrollTarget > 0 then
        self.ScrollTarget = self.ScrollTarget + (0 - self.ScrollTarget)*dt*12
    elseif self.ScrollTarget < -MaxScroll then
        self.ScrollTarget = self.ScrollTarget + (-MaxScroll - self.ScrollTarget)*dt*12
    end

    self:SetConstraint("Scroll", "ChildRect", Rect.new(Vector2.new(0,self.ScrollPosition), self.AbsoluteSize))
end

return ScrollContainer