local Template = {}

function Template.Create(Info)
    local PropertyObject = {}
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), Info.Parent)

    PropertyObject.PropertyVal = Studio.Components.PropertyValue(PropertyList, {
        Title = Info.Name,
        Type = "Button",
        Disabled = Info.Disabled,
        StyleSelect = true,
        UserRequest = function(Change)
            Platform.OpenWithCallback("Select the resource for this property.", Enum.OpenDialog.File, function(NewPath) -- Make this check attributes before actually setting thing resource (aka to limit stuff like an Audio thiing resource being set as a image ect ect@!!)
                local Identifier, _ = Runtime.Resources.LoadIdentifierIDFromPath(NewPath)
                if (not Identifier) then Utils.SendNotification("Couldnt find identifier, not supported yet perhaps...?","Error") return end

                Change(Identifier)
            end)
        end,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                Runtime.Things.SetProperty(Thing, Info.Name, InfoGiven)
            end
        end,
        ReturnDisplay = function()
            local IsAllSame = Utils.IsAllPropertiesTheSame(Studio.Editor3D.Selecting,Info.Name)
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name].Data.FileName) or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })

    return PropertyObject
end

return Template