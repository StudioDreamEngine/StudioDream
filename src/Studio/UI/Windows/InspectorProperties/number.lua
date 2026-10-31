local Number = Object:extend()

function Number:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function Number:Update()
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name
    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)

    self.Visual.Input:SetText(tostring(IsAllTheSame) or "~")
end

function Number:CreateVisual()
    local Visual = {}
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.Input = Studio.Components.CreateStyle("TextInput",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = tostring(IsAllTheSame) or "~",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value,
        Active = self.Property.IsActive
    })

    Visual.Input.FocusEnd:Connect(function(IsEnter)
        local Numberfied = tonumber(Visual.Input.Text)
        Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Numberfied)
        self:Update()
    end)

    self.Visual = Visual

    return Visual
end

function Number:Destroy()

end

return Number