local Template = {}

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)
    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Input",
        Disabled = Info.Disabled,
        StyleSelect = true,
        TrackObjects = {Things = Studio.Editor3D.Selecting,Property = Info.Name},
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, tonumber(InfoGiven))
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name]) or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    return PropertyObject
end

return Template