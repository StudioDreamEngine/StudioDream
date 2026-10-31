local Number = Object:extend()

local SelectionManager = Studio.Editor3D.SelectionManager

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

    local ToDisplay
    local Thing = Selecting[1].Resource

    if IsAllTheSame and Thing then
        ToDisplay = Runtime.Resources.GetIdentifierFromID(Thing).Data.FileStem
    else
        ToDisplay = "~"
    end

    self.Visual.Button:SetText(ToDisplay)
end

function Number:CreateVisual()
    local Visual = {}
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name

    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)
    
    Visual.Button = Studio.Components.CreateStyle("TextButton",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        ForegroundTransparency = (self.Property.IsActive and 0 or 0.5),
        Text = "~",
        Size = Pivot2D.FromScale(1,1),
        ForegroundColor = "Text",
        Name = "Warning",
        CornerRadius = 5,
        Alignment = Vector2.new(0.5,0.5),
        Parent = self.Property.Visual.Value,
        Active = self.Property.IsActive
    })

    Visual.Button.Clicked:Connect(function(IsEnter)
        Studio.Components.OpenResourcePicker(function(Resource)
            print("coil")
            print(Resource)
            print(Selecting, PropertyName, Resource)
            Runtime.Things.SetPropertyMassive(Selecting, PropertyName, Resource)
            self:Update()
        end)
    end)

    self.Visual = Visual

    self:Update()

    return Visual
end

function Number:Destroy()
    if SelectionManager.ObjectPicker then
        SelectionManager.ObjectPicker = nil
        Runtime.Cursor.ChangeCursor("Main")
    end
end

return Number