local Things = Runtime.Things
local Inspector = {}

Inspector.Container = nil ---@class Square

local ValueToProperty = {
    ["Vector3"] = "Input",
    ["Transform3D"] = "Input"
}

local ScrollContainer

function Inspector.CreateProperty(Info)
    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,0.1), Info.Parent)

    Studio.Components.PropertyValue(PropertyList, {
        Title = "VectorTest",
        Type = "Input",
        Translate = Info.Type,
        StyleSelect = true,
        UserChange = function(Text)
            print(Text)
            print(Utils.TypeOf(Text))
        end,
        Update = function()
            return Vector3.zero
        end,
        Subs = {
            Studio.Components.PropertyValue(Studio.Components.PropertyList(Pivot2D.new(1,0,0,30), Info.Parent), {
                Title = "VectorTest",
                Type = "Input",
                Translate = Info.Type,
                StyleSelect = true,
                UserChange = function(Text)
                    print(Text)
                    print(Utils.TypeOf(Text))
                end,
                Update = function()
                    return Vector3.zero
                end,
            },{
                ValueContainer = "Secondary",
                Container = "Outline"
            })
        }
    },{
        ValueContainer = "Outline",
        Container = "Secondary"
    })
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

    Inspector.CreateProperty({
        Parent = ScrollContainer,
        Type = "Vector3"
    })
end

function Inspector.Update(dt)
    
end

return Inspector