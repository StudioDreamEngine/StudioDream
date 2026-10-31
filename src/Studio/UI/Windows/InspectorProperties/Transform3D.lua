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

    self.Visual.Button:SetText(tostring(IsAllTheSame) or "{~,~,~},{~,~,~}")
    self.Visual.Position.Button:SetText(tostring(IsAllTheSame.Position) or "~,~,~")
    self.Visual.Rotation.Button:SetText(tostring(IsAllTheSame:AsAngle():Deg()) or "~,~,~")
end

function Pivot2DS:CreateSubVisual(Type)
    local SubVis = {}

    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local Placement = Type == "Position" and 1 or 2
    local ParentTo = self.Property.Visual.Subs[Placement]

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)

    ParentTo.Container:SetText(Type)
    
    SubVis.Button = Studio.Components.CreateStyle("TextInput",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = (IsAllTheSame and tostring(IsAllTheSame[Type] or "?") or "~,~,~"),
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = ParentTo.Value,
        Active = self.Property.IsActive
    })

    SubVis.Button.FocusEnd:Connect(function(IsEnter)
        local IsRot = (Type=="Rotation")
        local TheVector = Vector3.FromString(SubVis.Button.Text)

        if IsRot then
            TheVector = TheVector:Rad()
        end

        for i,v in pairs(Selecting) do
            if v[PropertyName] then
                local Property = v[PropertyName]
                local TheTransform
                if Type == "Position" then
                    local Transform1 = Transform3D.FromPosition(TheVector)
                    print(Property:GetBasis())
                    local Transform2 = Property:GetBasis()

                    TheTransform = Transform1*Transform2
                else
                    local Transform1 = Transform3D.FromPosition(Property.Position)
                    local Transform2 = Transform3D.FromAngle(TheVector)
                    print(Transform1)
                    print(Transform2)
                    print(TheVector)
                    TheTransform = Transform1*Transform2
                end
                Runtime.Things.SetProperty(v,PropertyName,TheTransform)
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
        Text = tostring(IsAllTheSame) or "{~,~,~},{~,~,~}",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value,
        Active = self.Property.IsActive
    })

    Visual.Button.FocusEnd:Connect(function(IsEnter)
        Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Transform3D.FromString(Visual.Button.Text))
        self:Update()
    end)

    Visual.Position = self:CreateSubVisual("Position")
    Visual.Rotation = self:CreateSubVisual("Rotation")

    self.Visual = Visual

    self:Update()

    return Visual
end

function Pivot2DS:Destroy()

end

return Pivot2DS