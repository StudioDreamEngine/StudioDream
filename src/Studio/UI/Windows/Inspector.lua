local Things = Runtime.Things
local Inspector = {}

Inspector.LoadedConfigs = Utils.LoadModules("Studio/UI/Windows/InspectorPropertyConfigs/", true)

Inspector.Container = nil ---@class Square

Inspector.Cleared = Signal:New("InspectorCleared!")

local ScrollContainer
local SearchBar

local SearchText = ""
local LoadedGroups = {}

function Inspector.CreateProperty(PropertyInfo)
    local BaseSquare = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.new(1,0,0,20),
        BackgroundTransparency = 1,
        Parent = PropertyInfo.Parent,
        Name = PropertyInfo.Name.."_Inspector"
    })
    
    local GiveInfo = {
        Parent = BaseSquare,
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
    else
        local Return = Inspector.LoadedConfigs.NotFound.Create(GiveInfo)
        Return.PropertyVal.UI.Container.Name = PropertyInfo.Name
    end
end

function Inspector.CreateGroup(GroupName)
    local Group = {}

    Group.BaseGroup = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.new(1,0,0,26),
        BackgroundColor = Studio.CurrentTheme.Outline,
        Layer = 3,
        Parent = ScrollContainer,
        Name = GroupName,
        CornerRadius = 2,
    })

    Group.TextOfGroup = Studio.Components.CreateStyle("Text", {
        Size =  Pivot2D.FromScale(0.5,0.8),
        Position = Pivot2D.FromScale(0.02,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = GroupName,
        Parent = Group.BaseGroup,
        BackgroundTransparency = 1,
        ForegroundColor = "Text",
        Font = Studio.CurrentTheme.FontBold,
    })

    ExpandableDropdown = Studio.Components.ExpandableDropdown(Group.BaseGroup, ScrollContainer)
    
    Group.BaseGroup.Dropdown = ExpandableDropdown.Container

    return ExpandableDropdown.Container
end

function Inspector.RenderEverything()
    Inspector.Clean()

    ScrollContainer.ScrollPosition = -200
    ScrollContainer:SetScroll(0)
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
    
    for GroupName,GroupData in pairs(LoadedGroups) do
        local GroupNode = Inspector.CreateGroup(GroupName)
        for Property, Thing in pairs(GroupData) do
            --print(Utils.TypeOf(Thing[Property]),Property)

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
        Serializable = false,
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