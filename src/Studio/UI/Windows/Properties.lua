local Things = Runtime.Things
local Properties = {}

--[[
    We need a system that is able to handle several property changes at once
    
]]

Properties.Container = nil ---@class Square
Properties.ParentWith = nil
Properties.PropertiesRequired = {}

Properties.DestroyCalls = {}

Properties.ResetSignal = Signal:New("Reset")

local Types = Utils.LoadModules("Studio/UI/Windows/PropertiesTypes/", true)

function Properties.CreateProperty(PropertyInfos,ParentWhat)
    local selfed = {}

    local PropertyWillHandle = {}

    for i,v in pairs(Editor3D.Selecting) do 
        table.insert(PropertyWillHandle,{
            Thing = v,
            Property = PropertyInfos.Name
        })
    end

    --print(PropertyWillHandle)
    selfed.BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,0.99,23,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.CurrentTheme.Secondary,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        CornerRadius = 6,
        --OutlineColor = Studio.Theme.CurrentTheme.Outline,
        --OutlineSize = 1
    }

    selfed.Option = Things.Create("Square") {
        Size = Pivot2D.FromScale(0.49,.8),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        Layer = 3,
        Parent = selfed.BaseProperty,
        CornerRadius = 6,
    }

    selfed.Text = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.49,.9),
        Position = Pivot2D.FromScale(0.005,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = PropertyInfos.Name,
        Parent = selfed.BaseProperty,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.CurrentTheme.Text
    }

    selfed.Connections = PropertyInfos.Connections
    selfed.WillHandle = PropertyWillHandle

    return selfed
end

function Properties.CreateGroup(GroupName)
    local Group = {}

    Group.BaseGroup = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,26,0),
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        Layer = 3,
        Parent = Properties.ParentWith,
        CornerRadius = 2,
    }

    Group.TextOfGroup = Things.Create("Text") {
        Size =  Pivot2D.FromScale(0.5,0.8),
        Position = Pivot2D.FromScale(0.02,0.5),
        Pivot = Vector2.new(0,0.5),
        Text = GroupName,
        Parent = Group.BaseGroup,
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.CurrentTheme.Text2,
        Font = Studio.Theme.CurrentTheme.FontBold,
    }

    ExpandableDropdown = Studio.Components.ExpandableDropdown(Group.BaseGroup, Properties.ParentWith)

    return ExpandableDropdown.Container
end

function Properties.Clear()
    Properties.ParentWith:ClearAllChildren({"ListLayout"})

    for _, Function in pairs(Properties.DestroyCalls) do
        Function()
    end

    Properties.DestroyCalls = {}
end

function Properties.RenderEverything(Thing)
    --print(Editor3D.Selecting)
    Properties.ParentWith.ScrollPosition = -200

    Properties.Clear()
    Properties.ParentWith:SetScroll(0)

    for GroupName, GroupData in pairs(Thing.Proxy.Groups) do
        local GroupNode = Properties.CreateGroup(GroupName)

        for _, Property in pairs(GroupData) do
            local PropertyInfo = {
                Name = Property,
                Thing = Thing,
                Type = Thing.Proxy.Types[Property],
                Connections = {}
            }

            local Required = (((PropertyInfo.Thing.Proxy.Attributes[Property] and Types[PropertyInfo.Thing.Proxy.Attributes[Property].RenderType]) or Types[PropertyInfo.Type]) or Types.NotFound)
            --print(Required)
            local Property = Properties.CreateProperty(PropertyInfo,GroupNode)
            local HandlerObject = Required.Start(Property)

            if HandlerObject.Destroy then
                table.insert(Properties.DestroyCalls, HandlerObject.Destroy)
            end

            for _,Info in pairs(Property.WillHandle) do
                --print(PropertyInfo.Property)
                table.insert(PropertyInfo.Connections,Info.Thing.PropertyChanged:ConnectDeferred(function() 
                    HandlerObject.Update() 
                end, PropertyInfo.Name))

                -- MY IDEA: property attributes enable for the creation of stuff such as playback buttons
                --for _, Attribute in pairs(Info.Attributes) do  
                --end
            end

            table.insert(PropertyInfo.Connections, Properties.ResetSignal:Connect(function()
                for _,v in pairs(PropertyInfo.Connections) do v:Disconnect() end
                PropertyInfo.Connections = {}
            end))
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
    Studio.Editor3D.OnDeselect:Connect(Properties.Clear)
end

function Properties.Update(dt)
    
end

return Properties