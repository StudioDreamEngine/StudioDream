local Template = {}

function Template.AudioExtra(Info,AddInfo)
    local BaseSquare = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.new(0.9,0,0,20),
        BackgroundTransparency = 1,
        Parent = AddInfo.Parent,
    })
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,1), BaseSquare)
    Studio.Components.PropertyValue(PropertyList, {
        Title = "Play Audio",
        Type = function(Parent, Info)
        local CanBeActive

        if Info.Disabled then
            CanBeActive = false
        else
            CanBeActive = true
        end
        -- Mikls code.. im lazy...
        local LineUp = {
            ["true"] = Vector2.new(0,0),
            ["false"] = Vector2.new(64,0),
        }

        local Value

        ---@class ImageButton
        local Button = Studio.Components.CreateStyle("ImageButton",{
            Resource = "Internal/Studio/PauseAnPlay.png",
            Size = Pivot2D.FromScale(1,1),
            SquareAxis = Enum.SquareAxis.Y,
            Parent = Parent,
            ForegroundColor = "Text",
            SinkHovering = true,
            ForegroundTransparency = Info.Disabled and 0.5 or 0,
            Active = CanBeActive,
        })

        Button.Clicked:Connect(function()
            if not Info.Disabled then
                Info.OnChange(not Value)
            end
        end)
            return function(InValue)
                Value = Utils.Boolean(InValue)
                Button:SetImageRect(Rect.new(LineUp[(type(InValue) == "string" and InValue or Value)],Vector2.new(64,64)))
            end
        end,
        Disabled = Info.Disabled,
        StyleSelect = true,
        UserChange = function(InfoGiven)
            for _,Thing in pairs(Studio.Editor3D.Selecting) do
                if Thing.Proxy.Attributes[Info.Name].RenderExtra == AddInfo.Name then
                    BaseSquare:AddPlaceholderSignal(BaseSquare.OnDestroy:Connect(function()
                        Thing:Stop()
                    end))
                    print(Thing.Playing)
                    if Thing.Playing then
                        Thing:Pause()
                    else
                        Thing:Play()
                    end
                end
            end
        end,
        ReturnDisplay = function()
           return not Studio.Editor3D.Selecting[1].Playing
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
            return IsAllSame and tostring(Studio.Editor3D.Selecting[1][Info.Name] and Studio.Editor3D.Selecting[1][Info.Name].Data.FileStem or "No Resource Set.") or "~"
        end
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })
    
    Studio.Components.CreateStyle("ImageButton",{
        Resource = "Internal/Studio/InsertResource.png",
        Size = Pivot2D.FromScale(0.8,0.8),
        BackgroundColor = "Text",
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = PropertyObject.PropertyVal.UI.ValueContainer,
        IgnoreConstraints = true,
        ImageRect = Rect.new(Vector2.new(64,0),Vector2.new(64,64)),
        ForegroundColor = "Text",
    })

    if Info.Attributes then
        PropertyObject.SubContainer = Studio.Components.ExpandableDropdown(PropertyObject.PropertyVal.UI.ValueContainer,Info.UltraParent)
        PropertyObject.SubContainer.Container.Name = Info.Name.."1"

        for i,v in pairs(Info.Attributes) do
            if v == "Audio" then
                Template.AudioExtra(Info,{
                    Name = v,
                    Parent = PropertyObject.SubContainer.Container
                })
            end
        end
    end

    return PropertyObject
end

return Template