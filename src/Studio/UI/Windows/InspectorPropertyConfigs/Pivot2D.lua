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
        Disabled = Info.Disabled,
        StyleSelect = true,
        Objects = {Things = Studio.Editor3D.Selecting,Property = Info.Name},
        UserChange = function(InfoGiven)
            local IsOffset = (AddInfo.Name == "Offset")
            local Vectorized = Vector2.FromString(InfoGiven)

            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                if not IsOffset then
                    FinalPivot = Pivot2D.FromAxises(Vectorized,Thing[Info.Name].Offset)
                else
                    FinalPivot = Pivot2D.FromAxises(Thing[Info.Name].Scale,Vectorized)
                end

                Runtime.Things.SetProperty(Thing, Info.Name, FinalPivot)
            end
        end,
        ReturnDisplay = function(Object, Same)
            local IsOffset = (AddInfo.Name == "Offset")
            local ReturnTheSame

            if not IsOffset then
                ReturnTheSame = Object[Info.Name].Scale
            else
                ReturnTheSame = Object[Info.Name].Offset
            end

            return ReturnTheSame
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
        Objects = {Things = Studio.Editor3D.Selecting,Property = Info.Name},
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        ReturnDisplay = function(Object)
            return Object[Info.Name]
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    PropertyObject.SubContainer = Studio.Components.ExpandableDropdown(PropertyObject.PropertyVal.UI.ValueContainer,Info.UltraParent)
    PropertyObject.SubContainer.Container.Name = Info.Name.."1"

    CreateSub(Info,{
        Name = "Scale",
        Parent = PropertyObject.SubContainer.Container
    })

    CreateSub(Info,{
        Name = "Offset",
        Parent = PropertyObject.SubContainer.Container
    })

    return PropertyObject
end

return Template