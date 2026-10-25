local Color = Object:extend()

function Color:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function Color:Update(Data)

end

function Color:CreateVisual()
    local Visual = {}
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.Button = Studio.Components.CreateStyle("TextButton",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = tostring(IsAllTheSame) or "~,~,~",
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
        BackgroundColor = IsAllTheSame or Color.new(0.5,0.5,0.5),
        CornerRadius = 100,
        Parent = self.Property.Visual.Value,
    })

    Visual.Button.Clicked:Connect(function()
        print("Helo")
        Studio.Layout.CallHandle("Windows.ColorPicked", "RequestApply", ColorOfThings, function(ReturnedColor)
            Runtime.Things.SetPropertyMassive(Selecting, PropertyName, ReturnedColor)
            print(ReturnedColor)
            Visual.Button:SetText(tostring(ReturnedColor))
            Visual.ColorSquare.BackgroundColor = ReturnedColor
        end)
    end)

    return Visual
end

function Color:Destroy()

end

return Color