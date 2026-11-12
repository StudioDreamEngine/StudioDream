local ColorP = Object:extend()

function ColorP:new(Property)
    --self.Asset = self:CreateProperty()
    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function ColorP:Update()
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name
    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    self.Visual.Button:SetText(IsAllTheSame and "[...]" or "[~]")
end

function ColorP:CreateVisual()
    local Visual = {}
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.Button = Studio.Components.CreateStyle("TextButton",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = IsAllTheSame and "[...]" or "[~]",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value,
        Active = self.Property.IsActive
    })

    Visual.ColorSquare = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
        BackgroundTransparency = 0,
        Layer = 2,
        BackgroundColor = Color.new(1,1,1),
        Gradient = IsAllTheSame or GradientSequence.DefaultSequence(),
        CornerRadius = 100,
        Parent = self.Property.Visual.Value,
    })
    
    Visual.Button.Clicked:Connect(function()
        local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)

        Studio.Layout.CallHandle("Windows.GradientMaker", "Request", Visual.ColorSquare.Gradient, function(ReturnedColor)
            Runtime.Things.SetPropertyMassive(Selecting, PropertyName, ReturnedColor)
            Visual.Button:SetText(IsAllTheSame and "[...]" or "[~]")
            Visual.ColorSquare:SetGradient(ReturnedColor)
        end)
    end)

    self.Visual = Visual

    return Visual
end

function ColorP:Destroy()

end

return ColorP