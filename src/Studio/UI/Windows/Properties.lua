local Things = Runtime.Things
local Properties = {}

Properties.Container = nil ---@class Square

Properties.ParentWith = nil

Properties.PropertiesRequired = {}

local Types = Utils.LoadModules("Studio/UI/Windows/PropertiesTypes/", true)

function Properties.CreateProperty(PropertyInfos,ParentWhat)
    local selfed = {}

    local PropertyWillHandle = {
        {
            Thing = PropertyInfos.Thing,
            Property = PropertyInfos.Name
        },
    }

    selfed.BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,0.99,20,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        CornerRadius = 6,
        --OutlineSize = 2,
        --OutlineColor = Studio.Theme.GetCurrentTheme().Outline
    }

    selfed.Option = Things.Create("Square") {
        Size = Pivot2D.FromScale(0.5,1),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = selfed.BaseProperty,
        CornerRadius = 2,
    }

    selfed.Text = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.49,.9),
        Position = Pivot2D.FromScale(0.005,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = PropertyInfos.Name,
        Parent = selfed.BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }

    selfed.Connections = PropertyInfos.Connections
    
    selfed.WillHandle = PropertyWillHandle
    
    return selfed
end

function Properties.CreateGroup(GroupName,ParentWhat)
    local Group = {}

    Group.Connections = {} -- this will also handle Property connections, so when reloading they all disconnect
    Group.IsOpen = true
    
    Group.BaseGroup = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,25,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        CornerRadius = 2,
    }

    Group.TextOfGroup = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,0.8),
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = GroupName,
        Parent = Group.BaseGroup,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text2,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
    }

    Group.Button = Runtime.Things.Create("ImageButton") {
        Resource = "Internal/Icons/Engine/OpenMenu.png",
        Size = Pivot2D.FromScale(1,0.8),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Text,
        SquareAxis = Enum.SquareAxis.Y, -- Would be much simplier if we had ScaleType or something but idk!@!
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Parent = Group.BaseGroup,
        Rect = Rect.new(Vector2.new(64,0),Vector2.new(64,64))
    }

    Group.List = Things.Create("Square") { 
        Size = Pivot2D.FromScale(.98,1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0.5,1),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        OutlineSize = 2,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
        CornerRadius = 2,
    }
    
    Group.ListLayout = Things.Create("ListLayout") {
        Parent = Group.List,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 2,
    }
    
    function Group.Toggle(Toggle) 
        Group.IsOpen = Toggle
        Group.List:SetVisible(Toggle)

        Group.Button:SetImageRect(Rect.new(Vector2.new(Toggle and 64 or 0, 0),Vector2.new(64,64)))
    end

    Group.Toggle(true)
    table.insert(Group.Connections, Group.Button.Clicked:Connect(function()
        Group.Toggle(not Group.IsOpen)
    end))

    return Group
end

function Properties.RenderEverything(Thing)
    Properties.ParentWith:ClearAllChildren({"ListLayout"})

    for GroupName, GroupData in pairs(Thing.Proxy.Groups) do
        local GroupNode = Properties.CreateGroup(GroupName)
        local GroupToParent = GroupNode.List

        for _, Property in pairs(GroupData) do
            local PropertyInfo = {
                Name = Property,
                Thing = Thing,
                Type = Thing.Proxy.Types[Property],
                Connections = GroupNode.Connections
            }

            local Required = Types[PropertyInfo.Type] or Types.NotFound

            local Property = Properties.CreateProperty(PropertyInfo,GroupToParent)
            Required.Start(Property)
        end
    end
end

function Properties.Init()
    Properties.ParentWith = Things.Create("ScrollContainer") { 
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0.5,0.5),
        Position = Pivot2D.FromScale(0.5,0.5),
        Parent =  Properties.Container,
    }

    Things.Create("ListLayout") {
        Parent = Properties.ParentWith,
        Alignment = Enum.Alignment.TopCenter,
        Padding = 2
    }
    Studio.Editor3D.OnSelect:Connect(Properties.RenderEverything)
end

function Properties.Update(dt)
    
end

return Properties