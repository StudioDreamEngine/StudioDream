local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class ScrollContainer: Viewport2D
local ScrollContainer = Things.Extend("Viewport2D")

function ScrollContainer:new()
    ScrollContainer.super.new(self)

    self.WheelMoved = LoveEvents.WheelMoved:Connect(function(_, y)
        print(y>0 and "up" or "down")
    end)

    --self:BindConstraint("Scroll", "ChildRect")
end

function ScrollContainer:OnRemove()
    ScrollContainer.super.OnRemove(self)
end

function ScrollContainer:Update(dt)
    ScrollContainer.super.Update(self, dt)

    --self:SetConstraint("Scroll", "ChildRect", Rect.new(Vector2.new(0,0), Vector2.new(50,50)), true)
end

return ScrollContainer