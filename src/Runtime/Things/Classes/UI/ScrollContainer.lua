local Things = Runtime.Things

-- My idea for this is someth like the list layouts, using the constraint system
---@class ScrollContainer: Viewport2D
local ScrollContainer = Things.Extend("Viewport2D")

function ScrollContainer:new()
    ScrollContainer.super.new(self)

    self.WheelMoved = LoveEvents.WheelMoved:Connect(function(_, y)
        
    end)

    --self:BindConstraint(self, "Rect")
end

function ScrollContainer:Update(dt)
    ScrollContainer.super.Update(self, dt)

    --self:SetConstraint(self, "Rect", Rect.new(Vector2.new(0,math.sin(GlobalTick)*100), Vector2.new(100,100)))
end

return ScrollContainer