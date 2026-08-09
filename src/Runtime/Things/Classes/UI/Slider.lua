local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Slider: BaseGui
local Slider = Things.Extend("BaseGui")

function Slider:new()
    Slider.super.new(self)

    self.MaxiumNumber = 50
    self.MinimumNumber = 0

    self.NumberPosition = 0

    self.SliderPosition = 0

    self.Hovering = false

    self.Holding = false

    self.SlidePivot = Vector2.new(0,0)
    self.SlideAbsolutePivot = Vector2.zero

    Runtime.InterfaceManager.OnClick:Connect(function(Vec)
        if not self.Hovering then return end
        
        self.Holding = true
        
    end)
    Runtime.InterfaceManager.OnRelease:Connect(function()
        self.Holding = false
    end)
end

function Slider:OnInitalParent(NewParent)
    Slider.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function Slider:SetSliderPosition(NewNumber)
    self.SlideAbsolutePivot = (self.SlidePivot*self.AbsoluteSize)

    local Percentage = math.clamp(((NewNumber-self.AbsolutePosition.X)/self.AbsoluteSize.X),0,1)
    self.SliderPosition = (Percentage * self.AbsoluteSize.X)
    self.AbsoluteNumberPosition = Percentage*100

    self.NumberPosition = math.clamp(self.MaxiumNumber*Percentage,self.MinimumNumber,self.MaxiumNumber)

    print(self.SliderPosition)
    print(self.NumberPosition)
    print(self.SlideAbsolutePivot,self.AbsoluteSize)
    print(self.AbsolutePosition)
end

function Slider:OnRemove()
    Slider.super.OnRemove(self)

    self.Hovering = false
    self.Clicked:DisconnectAll()
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function Slider:Draw()
    local Size = self.AbsoluteSize 
    if self.Holding then
        self:SetSliderPosition(Runtime.Backend2D.GetMousePosition().X)
    end
    love.graphics.push()
    love.graphics.setColor(1,1,1,1)
    love.graphics.translate(self.SliderPosition, 0)
    love.graphics.rectangle("fill", -self.SlideAbsolutePivot.X, -self.SlideAbsolutePivot.Y, Size.X/10, Size.Y/2)
    love.graphics.pop()
end

return Slider