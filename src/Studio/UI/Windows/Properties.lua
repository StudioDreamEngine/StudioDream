local Things = Runtime.Things
local Properties = {}

--[[
    We need a system that is able to handle several property changes at once
    
]]

Properties.Container = nil ---@class Square
Properties.ParentWith = nil
Properties.PropertiesRequired = {}

Properties.ResetSignal = Signal:New("Reset")

local Types = Utils.LoadModules("Studio/UI/Windows/PropertiesTypes/", true)

function Properties.CreateProperty(PropertyInfos,ParentWhat)
    local selfed = {}

    local PropertyWillHandle = {
        {
            Thing = PropertyInfos.Thing,
            Property = PropertyInfos.Name -- DONT FORGET TO ALSO MAKE ATTRIBUTES IN HERE!!! so if like i change a resource that inst compatiable with an property that is together it doesnt change the property
        },
    }

    selfed.BaseProperty = Things.Create("Square") { 
        Size = Pivot2D.new(0,0.99,23,0),
        Pivot = Vector2.new(0,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Secondary,
        Layer = 3,
        Parent = ParentWhat or Properties.ParentWith,
        CornerRadius = 6,
        OutlineColor = Studio.Theme.GetCurrentTheme().Outline,
        OutlineSize = 1
    }

    selfed.Option = Things.Create("Square") {
        Size = Pivot2D.FromScale(0.49,.8),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0,0.5),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
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
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text
    }

    selfed.Connections = PropertyInfos.Connections
    selfed.WillHandle = PropertyWillHandle

    return selfed
end

function Properties.CreateGroup(GroupName)
    local Group = {}

    Group.BaseGroup = Things.Create("Square") { 
        Size = Pivot2D.new(0,1,26,0),
        BackgroundColor = Studio.Theme.GetCurrentTheme().Outline,
        Layer = 3,
        Parent = Properties.ParentWith,
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

    ExpandableDropdown = Studio.Components.ExpandableDropdown(Group.BaseGroup, Properties.ParentWith)

    return ExpandableDropdown.Container
end

function Properties.RenderEverything(Thing)
    Properties.ResetSignal.Invoke()
    Properties.ParentWith:ClearAllChildren({"ListLayout"})
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

            local Required = Types[PropertyInfo.Type] or Types.NotFound

            local Property = Properties.CreateProperty(PropertyInfo,GroupNode)
            local Started = Required.Start(Property)

            for _,Info in pairs(Property.WillHandle) do
                table.insert(PropertyInfo.Connections,Info.Thing.PropertyChanged:Connect(function(NewVal,WhatProperty)
                    if WhatProperty == Info.Property and Required.Update then
                        Started.Update(NewVal)
                    end
                end))

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
end

function Properties.Update(dt)
    
end

return Properties