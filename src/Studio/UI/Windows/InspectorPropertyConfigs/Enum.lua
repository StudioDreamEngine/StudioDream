local Template = {}

local function BuildChoices(Table)
    local BuildedTable = {}
    for ValName,Val in pairs(Table) do
        if ValName ~= "Type" then
            if type(Val) ~= "function" then
                table.insert(BuildedTable,ValName)
            end
        end
    end
    return BuildedTable
end

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)
    local EnumList = table.clone(Studio.Editor3D.Selecting[1].Proxy.Enums[Info.Name])
    local TableBuilded = BuildChoices(Studio.Editor3D.Selecting[1].Proxy.Enums[Info.Name])
    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Dropdown",
        Disabled = Info.Disabled,
        StyleSelect = true,
        Choices = TableBuilded,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, EnumList[InfoGiven])
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and (EnumList.NameFromValue(Studio.Editor3D.Selecting[1][Info.Name]) or "???") or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    return PropertyObject
end

return Template