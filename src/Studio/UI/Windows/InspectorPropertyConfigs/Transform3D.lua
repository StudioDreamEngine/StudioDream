local Template = {}

local function CreateSub(Info,AddInfo)
    local BaseSquare = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.new(0.9,0,0,20),
        BackgroundTransparency = 1,
        Parent = AddInfo.Parent,
    })
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), BaseSquare)
    Studio.Components.PropertyValue(PropertyList, {
        Title = AddInfo.Name,
        Type = "Input",
        Translate = Info.Type,
        Disabled = Info.Disabled,
        StyleSelect = true,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        Update = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name][AddInfo.Name]) or "~"
        end
    },{
        ValueContainer = "Secondary",
        Container = "Outline"
    })
end

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)

    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Input",
        Translate = Info.Type,
        Disabled = Info.Disabled,
        StyleSelect = true,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        Update = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name]) or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })
    PropertyObject.SubContainer = Studio.Components.ExpandableDropdown(PropertyObject.PropertyVal.UI.ValueContainer,Info.UltraParent)
    PropertyObject.SubContainer.Container.Name = Info.Name.."1"
    CreateSub(Info,{
        Name = "Position",
        Parent = PropertyObject.SubContainer.Container
    })
    return PropertyObject
end

return Template