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
        UserChange = function(InfoGiven)
            local Vectorized = Vector3.FromString(InfoGiven)
            if AddInfo.Name == "Rotation" then
                Vectorized = Vectorized:Rad()
            end
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                local ReverseGivenFrom = ((AddInfo.TypeOf or AddInfo.Name)=="Angle"and"Position"or"Angle")
                local ReverseGiven = ((AddInfo.TypeOf or AddInfo.Name)=="Rotation"and"Position"or"Rotation")

                local FirstTransform = Transform3D["From"..(AddInfo.TypeOf or AddInfo.Name)](Vectorized.X,Vectorized.Y,Vectorized.Z)
                local BaseTransform 

                if ReverseGiven == "Rotation" then
                    local GotAngle = Thing.Transform.Rotation.AsAngle()
                    print(GotAngle)
                    BaseTransform = Transform3D.FromAngle(GotAngle.X,GotAngle.Y,GotAngle.Z)
                else
                    BaseTransform = Transform3D.FromPosition(Thing.Transform.Position.X,Thing.Transform.Position.Y,Thing.Transform.Position.Z)
                end

                print(BaseTransform)
                Runtime.Things.SetProperty(Thing, Info.Name,BaseTransform*FirstTransform)
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and tostring((
                AddInfo.Name ~= "Rotation" and Studio.Editor3D.Selecting[1][Info.Name][AddInfo.Name] or Studio.Editor3D.Selecting[1][Info.Name][AddInfo.Name].AsAngle():Deg())) 
                or "~"
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
        KeepTrackOf = {Things = Studio.Editor3D.Selecting,Property = Info.Name},
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        ReturnDisplay = function()
            print("updated!!!!!!!!!")
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
    CreateSub(Info,{
        Name = "Rotation",
        TypeOf = "Angle",
        Parent = PropertyObject.SubContainer.Container
    })
    return PropertyObject
end

return Template