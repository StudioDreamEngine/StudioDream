local StockVisuals = {}

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