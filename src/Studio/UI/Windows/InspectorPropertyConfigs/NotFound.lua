local Template = {}

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)

    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Input",
        Disabled = true,
        StyleSelect = true,
        UserChange = function(InfoGiven)
        end,
        ReturnDisplay = function()
            return "Unimplemented ("..Info.Type..")"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    return PropertyObject
end

return Template