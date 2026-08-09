local Things = Runtime.Things

-- using @module here gives the lua language server a base type to use!
---@class Slider: BaseGui
local Slider = Things.Extend("Square")

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

    self.SlideSizeAbsolute = Vector2.new(0,0)

    self.SlideAxis = Enum.SlideAxis.X

    self.SlideCornerRadius = 100
    self.LimitSlideCornerRadius = true
    self.SlideTrueRadiousOfCorners = 0

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

function Slider:DefineAPI()
    Slider.super.DefineAPI(self)

    self.Proxy.Property("number MaxiumNumber","number MinimumNumber","number SliderPosition","number NumberPosition","Vector2 SlidePivot","Enum.SlideAxis SlideAxis",
    "number SlideCornerRadius","boolean LimitSlideCornerRadius")
    self.Proxy.Icon("Slider")
    self.Proxy.Group("Number", "MaxiumNumber", "MinimumNumber", "NumberPosition")
    self.Proxy.Group("Transform", "SliderPosition","SlidePivot","SlideAxis","SlideCornerRadius","LimitSlideCornerRadius")
    self.Proxy.MakeCreatable()
end

function Slider:SetSliderPosition(NewNumber)
    local Percentage = math.clamp(((NewNumber-self.AbsolutePosition[self.SlideAxis])/self.AbsoluteSize[self.SlideAxis]),0,1)
    self.SlidePivot = self.AbsoluteSize*self.SlideSize * Percentage
    self.SliderPosition = (Percentage * self.AbsoluteSize[self.SlideAxis])
    self.AbsoluteNumberPosition = Percentage*100

    self.NumberPosition = math.clamp(self.MaxiumNumber*Percentage,self.MinimumNumber,self.MaxiumNumber)

    if self.LastNumPos ~= self.NumberPosition then
        self.NumberPosChanged.Invoke(self.NumberPosition)
        self.LastNumPos = self.NumberPosition
    end
end

function Slider:UpdateAbSize(Vec)
    self.SlideSizeAbsolute = self.AbsoluteSize*Vec
end

function Slider:SetNumberPosition(NewNumber)
    NewNumber = math.clamp(NewNumber,0,100)

    Slider:SetSliderPosition(self.SliderPosition/NewNumber)
end

function Slider:CalculateRadius() -- this was kinda fun to do
    if self.LimitSlideCornerRadius then
        local Size 
        --print(Size)
        if self.SlideSizeAbsolute.X < self.SlideSizeAbsolute.Y then
            Size = self.SlideSizeAbsolute.X/2
        else
            Size = self.SlideSizeAbsolute.Y/2
        end
        --print(Size)
        if self.SlideCornerRadius > Size then
            self.SlideTrueRadiousOfCorners = Size
        else
            self.SlideTrueRadiousOfCorners = self.SlideCornerRadius
        end
    else 
        self.SlideTrueRadiousOfCorners = self.SlideCornerRadius
    end
end

function Slider:OnRemove()
    Slider.super.OnRemove(self)

    self.Hovering = false
    self.Clicked:DisconnectAll()
    Runtime.InterfaceManager.UnregisterButton(self.UUID)
end

function Slider:Draw()
    Slider.super.Draw(self)
    local Size = self.AbsoluteSize

    if self.Holding then
        self:SetSliderPosition(Runtime.Backend2D.GetMousePosition()[self.SlideAxis])
    end

    self:CalculateRadius()
    self:UpdateAbSize(self.SlideSize)

    self:SetColor("AbsoluteForeground")

    if self.SlideAxis == "X" then
        love.graphics.rectangle("fill", self.SliderPosition - self.SlidePivot.X, 0, self.SlideSizeAbsolute.X, self.SlideSizeAbsolute.Y,self.SlideTrueRadiousOfCorners,self.SlideTrueRadiousOfCorners)
    else
        love.graphics.rectangle("fill", 0, self.SliderPosition - self.SlidePivot.Y, self.SlideSizeAbsolute.X, self.SlideSizeAbsolute.Y,self.SlideTrueRadiousOfCorners,self.SlideTrueRadiousOfCorners)
    end
end

return Slider