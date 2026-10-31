local Number = Object:extend()

local SelectionManager = Studio.Editor3D.SelectionManager

function Number:new(Property)
    --self.Asset = self:CreateProperty()

    self.Property = Property
    self.IsActive = Property.IsActive

    return self
end

function Number:GetIconResource(Thing)
    return "Internal/Studio/EditorIcons/"..Thing.Proxy.ExplorerIcon..".png"
end

function Number:Update()
    local Selecting = Studio.Editor3D.Selecting
    local PropertyName = self.Property.Name
    local IsAllTheSame = Runtime.Things.IsPropertiesTheSame(Selecting,PropertyName)

    self.Visual.Image:SetResource(IsAllTheSame and self:GetIconResource(IsAllTheSame) or "Internal/Studio/EditorIcons/Unkown.png")
    self.Visual.Button:SetText(IsAllTheSame and IsAllTheSame.Name or "~")
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

    Visual.Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/EditorIcons/Drawable3D.png",
        Parent = self.Property.Visual.Value,
    })

    Visual.Button.Clicked:Connect(function(IsEnter)
         if not SelectionManager.ObjectPicker then
            SelectionManager.ObjectPicker = Studio.Editor3D.Selecting[1]
            Runtime.Cursor.ChangeCursor("HoldingObj")

            Visual.Button:AddPlaceholderSignal(SelectionManager.ObjectPickerEvent:ConnectOnce(function(NewThing)
                Runtime.Things.SetPropertyMassive(Selecting, PropertyName, NewThing)
                self:Update()
            end))
        else
            SelectionManager.ObjectPicker = nil
            Runtime.Cursor.ChangeCursor("Main")
        end
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