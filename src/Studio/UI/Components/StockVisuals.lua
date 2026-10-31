local StockVisuals = {}

function StockVisuals:CreateSubProperty(Parent,MoreInfo)
    local Object = {}

    Object.Container = Studio.Components.CreateStyle("Text",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        Text = MoreInfo.Title,
        Size = MoreInfo.Size,
        ForegroundColor = "Text",
        Name = MoreInfo.Name or "Container",
        CornerRadius = 5,
        Alignment = Vector2.new(0.05,0.5),
        Parent = Parent
    })

    Object.Value = Studio.Components.CreateStyle("Square",{
        BackgroundTransparency = 0,
        BackgroundColor = "Secondary",
        Size = Pivot2D.FromScale(0.4,0.95),
        Position = Pivot2D.FromScale(1,0.5),
        Name = "Value",
        CornerRadius = 5,
        Pivot = Vector2.new(1,0.5),
        Parent = Object.Container
    })

    function Object:Destroy()
        for i,v in pairs(Object) do
            if Utils.TypeOf(v) == "Thing" then
                v:Destroy()
            end
        end
        table.clear(Object)
    end

    return Object
end

function StockVisuals:CreateSearchBar(Parent,MoreInfo)
    local Object = {}

    Object.SearchBar = Studio.Components.CreateStyle("TextInput",{
        Size = Pivot2D.FromScale(0.95,0.05),
        Position = Pivot2D.FromScale(0.5,0.005),
        Pivot = Vector2.new(0.5,0),
        ForegroundColor = "Text",
        BackgroundTransparency = 0,
        CornerRadius = 8,
        Layer = 2,
        BackgroundColor = "Outline",
        Alignment = Enum.Alignment.Center,
        Parent = Parent,
        ClearWhenFocus = true,
        Placeholder = MoreInfo.Search or "Search!"
    })
        
    Object.Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(1,1),
        Pivot = Vector2.new(0,0),
        Position = Pivot2D.FromScale(0,0),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Studio/Search.png",
        Parent = Object.SearchBar
    })

    function Object:Destroy()
        for i,v in pairs(Object) do
            if Utils.TypeOf(v) == "Thing" then
                v:Destroy()
            end
        end
        table.clear(Object)
    end

    return Object
end

function StockVisuals:CreateProperty(Parent,MoreInfo)
    local Object = {}

    Object.Container = Studio.Components.CreateStyle("Text",{
        BackgroundTransparency = 0,
        BackgroundColor = "Secondary",
        Text = MoreInfo.Title,
        Size = MoreInfo.Size,
        ForegroundColor = "Text",
        Name = MoreInfo.Name or "Container",
        CornerRadius = 5,
        Alignment = Vector2.new(0.05,0.5),
        Parent = Parent
    })

    Object.Value = Studio.Components.CreateStyle("Square",{
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        Size = Pivot2D.FromScale(0.4,0.95),
        Position = Pivot2D.FromScale(1,0.5),
        Name = "Value",
        CornerRadius = 5,
        Pivot = Vector2.new(1,0.5),
        Parent = Object.Container
    })

    if MoreInfo.HasSub then
        Object.ExpandableDropdown = Studio.Components.ExpandableDropdown(Object.Value, Parent)
        Object.ExpandableDropdown.Container.Name = Object.Container.Name.."1"
        Object.Subs = {}
        for i=1,MoreInfo.HasSub do
            Object.Subs[i] = StockVisuals:CreateSubProperty(Object.ExpandableDropdown.Container,{
                Name = MoreInfo.Name..tostring(i),
                Title = MoreInfo.Title,
                Size = MoreInfo.SizeSub,
            })
        end
    end

    function Object:Destroy()
        for i,v in pairs(Object) do
            if Utils.TypeOf(v) == "Thing" then
                v:Destroy()
            end
        end
        if Object.ExpandableDropdown then
            Object.ExpandableDropdown:Destroy()
            for i,v in pairs(Object.Subs) do
                v:Destroy()
            end
        end
        if Object.Subs then
            table.clear(Object.Subs)
        end
        table.clear(Object)
    end

    return Object
end

function StockVisuals:CreateBoolean(Parent)
    return Studio.Components.CreateStyle("ImageButton",{
        Resource = "Internal/Studio/Boolean.png",
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = Parent,
        ForegroundColor = "Text",
        SinkHovering = true,
    })
end

function StockVisuals:CreateGroup(Parent,MoreInfo)
    local Object = {}

    Object.BaseGroup = Studio.Components.CreateStyle("Text",{
        Size = Pivot2D.new(1,0,0,26),
        BackgroundColor = "Outline",
        BackgroundTransparency = 0,
        ForegroundColor = "Text",
        Font = "FontBold",
        Layer = 3,
        Parent = Parent,
        Name = MoreInfo.Name,
        Text = MoreInfo.Name,
        Alignment = Vector2.new(0.03,0.5),
        CornerRadius = 2,
    })

    Object.ExpandableDropdown = Studio.Components.ExpandableDropdown(Object.BaseGroup, Parent)

    Object.BaseGroup.Dropdown = Object.ExpandableDropdown.Container

    function Object:Destroy()
        Object.ExpandableDropdown:Destroy()
        Object.ExpandableDropdown = nil
        for i,v in pairs(Object) do
            if Utils.TypeOf(v) == "Thing" then
                v:Destroy()
            end
        end
        table.clear(Object)
    end

    return Object
end

return StockVisuals