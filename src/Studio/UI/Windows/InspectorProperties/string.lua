local String = Object:extend()

function String:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function String:Update(Data)

end

function String:CreateVisual()
    local Visual = {}
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.Button = Studio.Components.CreateStyle("TextInput",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = IsAllTheSame or "~",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value,
        Active = self.Property.IsActive
    })

    Visual.Button.FocusEnd:Connect(function(IsEnter)
        Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Visual.Button.Text)
    end)

    return Visual
end

function String:Destroy()

end

return String