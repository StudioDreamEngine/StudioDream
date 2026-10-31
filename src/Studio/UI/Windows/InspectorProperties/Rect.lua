local Pivot2DS = Object:extend()

function Pivot2DS:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function Pivot2DS:Update()
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name
    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)

    self.Visual.Button:SetText(tostring(IsAllTheSame) or "{~,~} , {~,~}")
    self.Visual.Origin.Button:SetText(tostring(IsAllTheSame.Origin) or "{~,~}")
    self.Visual.Size.Button:SetText(tostring(IsAllTheSame.Size) or "{~,~}")
end

function Pivot2DS:CreateSubVisual(Type)
    local SubVis = {}

    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local Placement = Type == "Origin" and 1 or 2
    local ParentTo = self.Property.Visual.Subs[Placement]

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)

    ParentTo.Container:SetText(Type)
    
    SubVis.Button = Studio.Components.CreateStyle("TextInput",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = (IsAllTheSame and tostring(IsAllTheSame[Type]) or "~,~"),
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = ParentTo.Value,
        Active = self.Property.IsActive
    })

    SubVis.Button.FocusEnd:Connect(function(IsEnter)
        local TheVector = Vector2.FromString(SubVis.Button.Text)
        for i,v in pairs(Selecting) do
            if v[PropertyName] then
                local Property = v[PropertyName]
                if Type == "Origin" then
                    NewPivot = Rect.new(TheVector,Property.Size)
                else
                    NewPivot = Pivot2D.new(Property.Origin,TheVector)
                end
                Runtime.Things.SetProperty(v,PropertyName,NewPivot)
                self:Update()
            end
        end
    end)

    return SubVis
end

function Pivot2DS:CreateVisual()
    local Visual = {}

    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.Button = Studio.Components.CreateStyle("TextInput",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = tostring(IsAllTheSame) or "{~,~} , {~,~}",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        BackgroundTransparency = 1,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value,
        Active = self.Property.IsActive
    })

    Visual.Button.FocusEnd:Connect(function(IsEnter)
        Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Rect.FromString(Visual.Button.Text))
        self:Update()
    end)

    Visual.Origin = self:CreateSubVisual("Origin")
    Visual.Size = self:CreateSubVisual("Size")

    self.Visual = Visual

    return Visual
end

function Pivot2DS:Destroy()

end

return Pivot2DS