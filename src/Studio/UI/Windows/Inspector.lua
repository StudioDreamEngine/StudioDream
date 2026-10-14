local Things = Runtime.Things
local Components = Studio.Components

return function(Inspector)
    function Inspector.CreateTreeObject(Obj,Group)
        local Obj = {}

        Obj.Asset = Obj
        Obj.Parenting = {}

        if Group then
            Obj.Parenting = nil
            Group.Parenting[Obj.Asset.Name] = Obj
        end

        return Obj
    end

    function Inspector.RenderProperty(PropertyGiven)
        local Property = {}

        

        return Property
    end

    function Inspector.RenderGroup(GroupName)
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

        Group.ExpandableDropdown = Studio.Components.ExpandableDropdown(Group.BaseGroup, ScrollContainer)

        function Group:RemoveProperty(Name)

        end

        Group.TreeObject = Inspector.CreateTreeObject(Group.BaseGroup)

        Inspector.RenderingTree[GroupName] = Group.TreeObject

        return Group
    end

    function Inspector.Render()
        local CleanTable = {}
        local HandlingThings = Studio.Editor3D.Selecting

        for _,Thing in pairs(HandlingThings) do
            for GroupName, GroupData in pairs(Thing.Proxy.Groups) do
                if not CleanTable[GroupName] then
                    CleanTable[GroupName] = {}
                end
                for Property, Thing in pairs(GroupData) do
                    CleanTable[GroupName][Property] = Thing.Proxy.Enums[Property] and "Enum" or Thing.Proxy.Types[Property]
                end
            end
        end

        for GroupName,Properties in pairs(CleanTable) then

            for PropertyName,Type in pairs(Properties) do
                
            end
        end
    end

    function Inspector.Setup()
        Inspector.Scroll = Studio.Components.CreateStyle("ScrollContainer",{
            Size = Pivot2D.FromScale(1,0.94),
            CanvasSize = Pivot2D.FromScale(1,4),
            BackgroundTransparency = 1,
            Pivot = Vector2.new(0.5,0),
            Position = Pivot2D.FromScale(0.5,0.06),
            Parent = Inspector.Container,
        })

        Inspector.List = Studio.Components.CreateStyle("ListLayout",{
            Parent = ScrollContainer,
            Alignment = Enum.Alignment.TopCenter,
            Padding = 2
        })
    end

    function Inspector.Init()
        Inspector.PropertyTypes = Utils.LoadModules("Studio/UI/Windows/InspectorProperties/", true)

        Inspector.RenderingTree = {}

        Inspector.Setup()
    end

    function Inspector.Update(dt)
        
    end

    return Inspector
end