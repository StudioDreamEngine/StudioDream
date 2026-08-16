local Things = Runtime.Things
local Inspector = {}

Inspector.LoadedConfigs = Utils.LoadModules("Studio/UI/Windows/InspectorPropertyConfigs/", true)

Inspector.Container = nil ---@class Square

local ScrollContainer
print(Inspector.LoadedConfigs)
function Inspector.CreateProperty(PropertyInfo)
    local BaseSquare = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.new(1,0,0,20),
        BackgroundTransparency = 1,
        Parent = PropertyInfo.Parent,
        Name = PropertyInfo.Name
    })
    local GiveInfo = {
        Parent = BaseSquare,
        UltraParent = PropertyInfo.Parent,
        Name = PropertyInfo.Name,
        Type = PropertyInfo.Type,
        Disabled = PropertyInfo.Thing.Proxy.Attributes[PropertyInfo.Name] and (PropertyInfo.Thing.Proxy.Attributes[PropertyInfo.Name].SeeOnlyInspect or false) or false
    }
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
    
    return ExpandableDropdown.Container
end

function Inspector.RenderEverything()
    Inspector.Clean()

    local LoadedGroups = {}

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
            local PropertyInfo = {
                Name = Property,
                Type = Thing.Proxy.Enums[Property] and "Enum" or Utils.TypeOf(Thing[Property]),
                Parent = GroupNode,
                Thing = Thing,
            }
            Inspector.CreateProperty(PropertyInfo)
        end
    end
end

function Inspector.Clean()
    ScrollContainer:ClearAllChildren({"ListLayout"})
end

function Inspector.Init()
    ScrollContainer = Studio.Components.CreateStyle("ScrollContainer",{
        Size = Pivot2D.FromScale(1,1),
        CanvasSize = Pivot2D.FromScale(1,4),
        BackgroundTransparency = 1,
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent = Inspector.Container,
        Serializable = false
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