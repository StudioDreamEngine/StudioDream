local String = Object:extend()

function String:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function String:BuildChoices(Table)
    local BuildedTable = {}

    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    for ValName,Val in pairs(Table) do
        if ValName ~= "Type" then
            if type(Val) ~= "function" then
                table.insert(BuildedTable,{
                    Text = ValName,
                    Type = "Button",
                    Function = function()
                        Runtime.Things.SetPropertyMassive(Selecting, PropertyName, self.Visual.EnumList[ValName])
                        self:Update()
                    end
                })
            end
        end
    end
    return BuildedTable
end

function String:Update()
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name
    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    self.Visual.Button:SetText(IsAllTheSame and self.Visual.EnumList.NameFromValue(IsAllTheSame) or "~")
end

function String:CreateVisual()
    local Visual = {}
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.EnumList = table.clone(Selecting[1].Proxy.Enums[PropertyName])
    Visual.TableBuilded = self:BuildChoices(Selecting[1].Proxy.Enums[PropertyName])

    Visual.Button = Studio.Components.CreateStyle("TextButton",{
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

    Visual.Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(1,0),
        Position = Pivot2D.FromScale(1,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/ScrollEnum.png",
        Parent = self.Property.Visual.Value,
    })

    Visual.Dropdown = Studio.Components.DropdownPlus.new(Visual.TableBuilded,Visual.Button)
    Visual.Dropdown.Toggle(false)
    Visual.Button.Clicked:Connect(function(IsEnter)
        --Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Visual.Button.Text)
        Visual.Dropdown.Toggle()
    end)

    self.Visual = Visual

    self:Update()

    return Visual
end

function String:Destroy()

end

return String