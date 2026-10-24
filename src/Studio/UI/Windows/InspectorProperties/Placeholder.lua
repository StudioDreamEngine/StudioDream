local Placeholder = Object:extend()

function Placeholder:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function Placeholder:ReAssing(Data)

end

function Placeholder:CreateVisual()
    local Visual = {}

    Visual.Text = Studio.Components.CreateStyle("Text",{
        BackgroundTransparency = 0,
        BackgroundColor = "Secondary",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = "This is a placeholder for "..self.Property.Type.." property!!!",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value
    })

    return Visual
end

function Placeholder:Destroy()

end

return Placeholder