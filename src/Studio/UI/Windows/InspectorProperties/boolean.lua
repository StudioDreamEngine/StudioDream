local boolean = Object:extend()

local LineUp = {
    ["true"] = Vector2.new(64,0),
    ["false"] = Vector2.new(128,0),
    ["nil"] = Vector2.new(0,0)
}

function boolean:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function boolean:Update(Data)

end

function boolean:CreateVisual()
    local Visual = {}

    function Visual.UpdateButton(NewRect)
        NewRect = tostring(NewRect)
        Visual.Button:SetImageRect(Rect.new(LineUp[NewRect],Vector2.new(64,64)))
    end

    Visual.Button = Studio.Components.CreateStyle("ImageButton",{
        Resource = "Internal/Studio/Boolean.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = self.Property.Visual.Value,
        ForegroundColor = "Text",
        SinkHovering = true,
        ForegroundTransparency = self.IsActive and 0 or 0.5
    })
    Visual.Button.Active = self.IsActive

    Visual.UpdateButton(Runtime.Things.IsPropertiesTheSame(Studio.Editor3D.Selecting,self.Property.Name))

    Visual.Button.Clicked:Connect(function()
        local Selecting = Studio.Editor3D.Selecting
        local PropertyName = self.Property.Name
        local Val = not Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
        
        Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Val)
        Visual.UpdateButton(Val)
    end)

    return Visual
end

function boolean:Destroy()

end

return boolean