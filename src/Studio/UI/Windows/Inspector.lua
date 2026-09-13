local Things = Runtime.Things

return function(Inspector)
    Inspector.LoadedConfigs = Utils.LoadModules("Studio/UI/Windows/InspectorPropertyConfigs/", true)

    Inspector.Cleared = Signal:New("InspectorCleared!")

    local ScrollContainer
    local SearchBar

    local SearchText = ""
    local LoadedGroups = {}

    function Inspector.CreateProperty(PropertyInfo)
        
        local GiveInfo = {
            Parent = PropertyInfo.Parent,
            UltraParent = PropertyInfo.Parent,
            Name = PropertyInfo.Name,
            Type = PropertyInfo.Type,
            Disabled = PropertyInfo.Thing.Proxy.Attributes[PropertyInfo.Name] and (PropertyInfo.Thing.Proxy.Attributes[PropertyInfo.Name].SeeOnlyInspect or false) or false,
            Attributes = PropertyInfo.Attributes
        }

        Inspector.Cleared:ConnectOnce(function()
            table.clear(GiveInfo)
        end)

        if Inspector.LoadedConfigs[PropertyInfo.Type] then
            local Return = Inspector.LoadedConfigs[PropertyInfo.Type].Create(GiveInfo)
            Return.PropertyVal.UI.Container.Name = PropertyInfo.Name
            Return.PropertyVal.UI.Container.Size = Pivot2D.new(1,0,0,20)
        else
            local Return = Inspector.LoadedConfigs.NotFound.Create(GiveInfo)
            Return.PropertyVal.UI.Container.Name = PropertyInfo.Name
            Return.PropertyVal.UI.Container.Size = Pivot2D.new(1,0,0,20)
        end
    end

    function Inspector.CreateGroup(GroupName)
        local Group = {}

        Group.BaseGroup = Studio.Components.CreateStyle("Text",{
            Size = Pivot2D.new(1,0,0,26),
            BackgroundColor = "Outline",
            BackgroundTransparency = 0,
            ForegroundColor = "Text",
            Font = "FontBold",
            Layer = 3,
            Parent = ScrollContainer,
            Name = GroupName,
            Text = GroupName,
            Alignment = Vector2.new(0.03,0.5),
            CornerRadius = 2,
        })

        ExpandableDropdown = Studio.Components.ExpandableDropdown(Group.BaseGroup, ScrollContainer)
        
        Group.BaseGroup.Dropdown = ExpandableDropdown.Container

        return ExpandableDropdown.Container
    end

    function Inspector.RenderEverything()
        Inspector.Clean()

        ScrollContainer:Present()
        LoadedGroups = {}

        for _,Thing in pairs(Studio.Editor3D.Selecting) do
            for GroupName, GroupData in pairs(Thing.Proxy.Groups) do
                if not LoadedGroups[GroupName] then
                    LoadedGroups[GroupName] = {}
                end
                for _,ProToAdd in pairs(GroupData) do
                    LoadedGroups[GroupName][ProToAdd] = Thing
                end
            end
        end

        local Start = os.clock()
        
        for GroupName,GroupData in pairs(LoadedGroups) do
            local GroupNode = Inspector.CreateGroup(GroupName)
            for Property, Thing in pairs(GroupData) do
                --print(Utils.TypeOf(Thing[Property]),Property)

                if os.clock() - Start > 1/80 then
                    Scheduler.Yield()
                    Start = os.clock()
                end

                xpcall(function()
                    local PropertyInfo = {
                        Name = Property,
                        Type = Thing.Proxy.Enums[Property] and "Enum" or Thing.Proxy.Types[Property],
                        Parent = GroupNode,
                        Thing = Thing,
                        Attributes = Thing.Proxy.Attributes[Property]
                    }
                    Inspector.CreateProperty(PropertyInfo)
                end, function(Error)
                    -- mikl istg
                    print(debug.traceback("Failed to create property node for "..Property..", "..Error))
                end)
            end
        end

        Inspector.UpdateList()
        print("Thing count: "..#ScrollContainer:GetDescendants())
    end

    function Inspector.Clean()
        ScrollContainer:ClearAllChildren({"ListLayout"})

        SearchBar:SetText("")
        SearchText = ""

        Inspector.UpdateList()
        table.clear(LoadedGroups)
        Inspector.Cleared.Invoke()
    end

    function Inspector.UpdateList()
        for _,GroupNode in pairs(ScrollContainer:GetChildren()) do
            if GroupNode.Dropdown then
                for i,v in pairs(GroupNode.Dropdown:GetChildren()) do
                    if (v:IsA("Square")) then
                        v:SetVisible((SearchText=='') and true or string.find(v.Name:lower(), SearchText:lower()))
                    end
                end
            end
        end
    end

    function Inspector.Init()

        SearchBar = Studio.Components.CreateStyle("TextInput",{
            Size = Pivot2D.FromScale(0.95,0.05),
            Position = Pivot2D.FromScale(0.5,0.005),
            Pivot = Vector2.new(0.5,0),
            ForegroundColor = "Text",
            BackgroundTransparency = 0,
            CornerRadius = 8,
            Layer = 2,
            BackgroundColor = "Outline",
            Alignment = Enum.Alignment.Center,
            Parent = Inspector.Container,
            ClearWhenFocus = true,
            Placeholder = "Search a thing class name!"
        })
        
        Studio.Components.CreateStyle("Image2D",{
            Size = Pivot2D.FromScale(1,1),
            Pivot = Vector2.new(0,0),
            Position = Pivot2D.FromScale(0,0),
            SquareAxis = Enum.SquareAxis.Y,
            Resource = "Internal/Studio/Search.png",
            Parent = SearchBar
        })

        SearchBar.Typed:Connect(function(NewText)
            SearchText = NewText
            Inspector.UpdateList()
        end)

        SearchBar.FocusEnd:Connect(function()
            Inspector.UpdateList()
        end)

        ScrollContainer = Studio.Components.CreateStyle("ScrollContainer",{
            Size = Pivot2D.FromScale(1,0.94),
            CanvasSize = Pivot2D.FromScale(1,4),
            BackgroundTransparency = 1,
            Pivot = Vector2.new(0.5,0),
            Position = Pivot2D.FromScale(0.5,0.06),
            Parent = Inspector.Container,
        })

        Studio.Components.CreateStyle("ListLayout",{
            Parent = ScrollContainer,
            Alignment = Enum.Alignment.TopCenter,
            Padding = 2
        })

        Studio.Editor3D.OnSelect:Connect(Inspector.RenderEverything)
        Studio.Editor3D.OnDeselect:Connect(Inspector.Clean)
    end

    function Inspector.Update(dt)
        
    end

    return Inspector
end