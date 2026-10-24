local Things = Runtime.Things
local Components = Studio.Components

return function(Inspector)
    function Inspector.CreateTreeObject(ObjGiven,Group)
        local Obj = {}

        Obj.Info = ObjGiven
        Obj.Parenting = {}

        if Group then
            Obj.Parenting = nil
            Group.Parenting[Obj.Info.Name] = Obj
        end

        function Obj:Destroy()
            if Obj.Parenting then
                for i,v in pairs(Obj.Parenting) do
                    v:Destroy()
                end
            else
                Group.Parenting[Obj.Info.Name] = nil
            end
        end

        function Obj:FindChild(Name)
            assert(Obj.Parenting, "This Inspector TreeObject is a property type one, it doesnt have parenting.")
            for i,v in pairs(Obj.Parenting) do
                if i == Name then
                    return v
                end
            end
        end

        return Obj
    end

    function Inspector.FindProperty(Type)
        if Inspector.PropertyTypes[Type] then
            return Inspector.PropertyTypes[Type]()
        else
            return Inspector.PropertyTypes.Placeholder()
        end
    end

    function Inspector.RenderProperty(Data,Group)
        local Property = {}

        Property.Name = Data.Name
        Property.Type = Data.Type

        Property.Visual = Studio.Components.StockVisuals:CreateProperty(Group:ReturnToParent(),{
            Title = Data.Name,
            Size = Pivot2D.new(1,0,0,20)
        })

        Property.IsActive = false

        Property.TreeObject = Inspector.CreateTreeObject(Property,Group.TreeObject)

        Property.Functionality = Inspector.FindProperty(Property.Type)
        Property.Functionality:new(Property)
        Property.Functionality:CreateVisual(Property)

        function Property:Destroy()
            Property.Visual:Destroy()
            Property.Visual = nil
            Property.TreeObject:Destroy()
            Property.TreeObject = nil
        end

        return Property
    end

    function Inspector.RenderGroup(GroupName)
        local Group = {}

        function Group:RemoveProperty(Name)
            local TreeFound = Group.TreeObject:FindChild(Name)
            if TreeFound then
                TreeFound.Info:Destroy()
                Group.TreeObject.Parenting[Name] = nil
            end
        end

        function Group:ReturnToParent()
            return Group.Visual.ExpandableDropdown.Container
        end

        Group.Name = GroupName
        Group.Visual = Studio.Components.StockVisuals:CreateGroup(Inspector.Scroll,{
            Name = GroupName,
        })

        Group.TreeObject = Inspector.CreateTreeObject(Group)
        Inspector.RenderingTree[GroupName] = Group.TreeObject

        function Group:Destroy()
            local Children = {}
            for _, Child in pairs(Group.TreeObject.Parenting) do
                table.insert(Children, Child)
            end
            for _, Child in ipairs(Children) do
                Child.Info:Destroy()
            end

            Group.Visual:Destroy()
            Group.TreeObject:Destroy()
            Inspector.RenderingTree[Group.Name] = nil

            Group.TreeObject = nil
            Group.Visual = nil
        end

        return Group
    end

    function Inspector.Clean()
        local Groups = {}
        for _, TreeObject in pairs(Inspector.RenderingTree) do
            table.insert(Groups, TreeObject.Info)
        end
        for _, Group in ipairs(Groups) do
            Group:Destroy()
        end
        table.clear(Inspector.RenderingTree)
    end

    function Inspector.Render()
        local CleanTable = {}
        local HandlingThings = Studio.Editor3D.Selecting
        Inspector.Clean()

        for _,Thing in pairs(HandlingThings) do
            for GroupName, GroupData in pairs(Thing.Proxy.Groups) do
                if not CleanTable[GroupName] then
                    CleanTable[GroupName] = {}
                end
                for _, Property in pairs(GroupData) do
                    CleanTable[GroupName][Property] = Thing.Proxy.Enums[Property] and "Enum" or Thing.Proxy.Types[Property]
                end
            end
        end

        for GroupName,Properties in pairs(CleanTable) do
            local Group = Inspector.RenderGroup(GroupName)
            for PropertyName,Type in pairs(Properties) do
                local Property = Inspector.RenderProperty({Name = PropertyName, Type = Type}, Group)
            end
        end

        table.clear(CleanTable)
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
            Parent = Inspector.Scroll,
            Alignment = Enum.Alignment.TopCenter,
            Padding = 2
        })

        Studio.Editor3D.OnSelect:Connect(Inspector.Render)
        Studio.Editor3D.OnDeselect:Connect(Inspector.Clean)
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