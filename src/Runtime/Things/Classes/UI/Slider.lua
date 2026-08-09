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

    self.LastNumPos = nil

    self.Hovering = false

    self.Holding = false

    self.SlidePivot = Vector2.new(0,0)
    self.SlideAbsolutePivot = Vector2.zero

    self.SlideSize = Vector2.new(0.1,1)

    self.NumberPosChanged = Signal:New("Slide_NumberPos")
    self.StartHolding = Signal:New("Slide_Hold")
    self.EndHolding = Signal:New("End_Hold")

    Runtime.InterfaceManager.OnClick:Connect(function(Vec)
        if not self.Hovering then return end
        
        self.Holding = true
        self.StartHolding.Invoke()
    end)

    Runtime.InterfaceManager.OnRelease:Connect(function()
        self.Holding = false
        self.EndHolding.Invoke()
    end)
end

function Slider:OnInitalParent(NewParent)
    Slider.super.OnInitalParent(self, NewParent)
    Runtime.InterfaceManager.RegisterButton(self.UUID)
end

function Slider:SetSliderPosition(NewNumber)
    local Percentage = math.clamp(((NewNumber-self.AbsolutePosition.X)/self.AbsoluteSize.X),0,1)
    self.SlidePivot = self.AbsoluteSize*self.SlideSize * Percentage
    self.SliderPosition = (Percentage * self.AbsoluteSize.X)
    self.AbsoluteNumberPosition = Percentage*100

    self.NumberPosition = math.clamp(self.MaxiumNumber*Percentage,self.MinimumNumber,self.MaxiumNumber)

    if self.LastNumPos ~= self.NumberPosition then
        self.NumberPosChanged.Invoke(self.NumberPosition)
        self.LastNumPos = self.NumberPosition
    end
    --print(self.SliderPosition)
    --print(self.NumberPosition)
    --print(self.SlideAbsolutePivot,self.AbsoluteSize)
    --print(self.AbsolutePosition)
end

function Slider:SetNumberPosition(NewNumber)
    NewNumber = math.clamp(NewNumber,0,100)

    Slider:SetSliderPosition(self.SliderPosition/NewNumber)
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

    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", self.SliderPosition -self.SlidePivot.X, 0, Size.X*self.SlideSize.X, Size.Y*self.SlideSize.Y)
end

return Slider