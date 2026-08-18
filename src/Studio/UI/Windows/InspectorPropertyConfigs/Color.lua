local Template = {}

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)

    local SquareColor = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
    })

    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Input",
        Translate = Info.Type,
        Disabled = Info.Disabled,
        StyleSelect = true,
        KeepTrackOf = {Things = Studio.Editor3D.Selecting,Property = Info.Name},
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            SquareColor.BackgroundColor = IsAllSame and Studio.Editor3D.Selecting[1][Info.Name] or Color.new(1)
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name]) or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    SquareColor:SetParent(PropertyObject.PropertyVal.UI.ValueContainer)

    return PropertyObject
end

return Template