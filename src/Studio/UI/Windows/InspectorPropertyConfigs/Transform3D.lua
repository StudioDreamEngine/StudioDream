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
            local IsRotation = (AddInfo.Name == "Rotation")
            local Vectorized = Vector3.FromString(InfoGiven)

            if IsRotation then
                Vectorized = Vectorized:Rad()
            end

            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                if IsRotation then
                    local Transform1 = Thing[Info.Name].PositionMatrix()
                    local Transform2 = Transform3D.FromAngle(Vectorized)

                    Runtime.Things.SetProperty(Thing, Info.Name, Transform1 * Transform2) 
                else
                    local Transform2 = Transform3D.FromPosition(Vectorized)
                    local Transform1 = Thing[Info.Name].Rotation

                    Runtime.Things.SetProperty(Thing, Info.Name, Transform2 * Transform1) 
                end
            end
        end,
        ReturnDisplay = function(Object)
            return AddInfo.Name ~= "Rotation" and Object[Info.Name][AddInfo.Name] or Object[Info.Name][AddInfo.Name].AsAngle():Deg()
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
        Name = "Position",
        Parent = PropertyObject.SubContainer.Container
    })

    CreateSub(Info,{
        Name = "Rotation",
        Parent = PropertyObject.SubContainer.Container
    })

    return PropertyObject
end

return Template