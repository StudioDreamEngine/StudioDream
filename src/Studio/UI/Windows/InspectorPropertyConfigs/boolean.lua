local Template = {}

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)
    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Checkbox",
        Disabled = Info.Disabled,
        StyleSelect = true,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, (not Studio.Editor3D.Selecting[1][Info.Name]))
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name]) or "nil"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    return PropertyObject
end

return Template