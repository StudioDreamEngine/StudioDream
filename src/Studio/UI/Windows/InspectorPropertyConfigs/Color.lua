local Template = {}

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)

    local SquareColor = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
        CornerRadius = 100,
    })

    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Button",
        Icon = true,
        Translate = Info.Type,
        Disabled = Info.Disabled,
        StyleSelect = true,
        Objects = {Things = Studio.Editor3D.Selecting,Property = Info.Name},
        UserRequest = function(Change)
            local ColorOfThings = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name) and Studio.Editor3D.Selecting[1][Info.Name] or Color.new(1)
            local ColorReturned = Studio.Layout.CallHandle("ColorPicked", "RequestApply", ColorOfThings)
            if ColorReturned~="ItFaliedBtw" then
                Change(tostring(ColorReturned))
            end
        end,
        UserChange = function(InfoGiven)
            if not InfoGiven then return end
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        ReturnDisplay = function(Object, Same)
            SquareColor.BackgroundColor = Object[Info.Name] and (Same and Object[Info.Name] or Color.new(1)) or SquareColor.BackgroundColor
            
            return Object[Info.Name]
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    SquareColor:SetParent(PropertyObject.PropertyVal.UI.ValueContainer)

    return PropertyObject
end

return Template