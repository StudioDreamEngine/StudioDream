local Template = {}

local SelectionManager = Studio.Editor3D.SelectionManager

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)

    local Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/EditorIcons/Drawable3D.png",
    })

    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Button",
        Disabled = Info.Disabled,
        StyleSelect = true,
        UserRequest = function(Change)
            if not SelectionManager.ObjectPicker then
                SelectionManager.ObjectPicker = Studio.Editor3D.Selecting[1]
                Runtime.Cursor.ChangeCursor("HoldingObj")

                PropertyObject.PropertyVal.UI.ValueContainer:AddPlaceholderSignal(SelectionManager.ObjectPickerEvent:ConnectOnce(function(NewThing)
                    Change(NewThing)
                    --Studio.Layout.CallHandle("Explorer", "Redraw")
                end))
            else
                SelectionManager.ObjectPicker = false
                Runtime.Cursor.ChangeCursor("Main")
            end
        end,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            local FirstObject = Studio.Editor3D.Selecting[1]
            Image:SetResource(IsAllSame and (FirstObject[Info.Name] and "Internal/Studio/EditorIcons/"..FirstObject[Info.Name].Proxy.ExplorerIcon..".png" or "Internal/Studio/EditorIcons/Drawable3D.png") or "Internal/Studio/EditorIcons/Drawable3D.png")
            return IsAllSame and tostring(FirstObject[Info.Name] and FirstObject[Info.Name].Name or "~") or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    Image:SetParent(PropertyObject.PropertyVal.UI.ValueContainer)

    return PropertyObject
end

return Template