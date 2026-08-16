local Things = Runtime.Things

return function(Args,SingleTab)
    
    local ButtonContainer = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.1,1),
        BackgroundTransparency = 0.5,
        Name = "ToolbarSnap",
        CornerRadius = 5,
       -- OutlineSize = 1.5,
        --OutlineColor = Studio.CurrentTheme.Outline
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = ButtonContainer,
        Padding = 0,
        Alignment = Enum.Alignment.Center
    })

    local PropertyList = Studio.Components.PropertyList(Pivot2D.FromScale(1,0.5), ButtonContainer)

    -- In the configs, we should have a function that still creates the container itself
    Studio.Components.PropertyValue(PropertyList, {
        Icon = "TabIcons/MoveIcon.png",
        Type = "Input",
        UserChange = function(Text)
            Studio.Editor3D.UpdateGrid("Grid",tonumber(Text) or 0.5)
        end,
        ReturnDisplay = function()
            return Studio.Editor3D.GridSnap
        end,
    })

    Studio.Components.PropertyValue(PropertyList, {
        Icon = "TabIcons/RotIcon.png",
        Type = "Input",
        UserChange = function(Text)
            Studio.Editor3D.UpdateGrid("Rotation",tonumber(Text) or 0.5)
        end,
        ReturnDisplay = function()
            return Studio.Editor3D.RotationSnap
        end,
    })

    --[[function CreateOption(Config)
        local Grid = Studio.Components.CreateStyle("Square",{
        Parent = ButtonContainer,
        Size = Pivot2D.FromScale(1,0.4),
        ForegroundColor = "Text",
        BackgroundTransparency = 0,
        BackgroundColor = "Outline",
        CornerRadius = 5,
    })
    Studio.Components.CreateStyle("Image2D",{
        Parent = Grid,
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Size = Pivot2D.FromScale(0.2,1),
        ForegroundColor = "Text",
        ScaleType = Enum.ScaleType.LockAspect,
        BackgroundTransparency = 1,
        Resource = Config.Icon
    })
    local Input = Studio.Components.CreateStyle("TextInput",{
        Parent = Grid,
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Size = Pivot2D.FromScale(0.8,1),
        ForegroundColor = "Text",
        BackgroundTransparency = 1,
        CornerRadius = 5,
        Alignment = Enum.Alignment.MiddleLeft,
        Placeholder = tostring(Studio.Editor3D[Config.SnapTo]),
        Text = "",
        ClearWhenFocus = true
    })
        Input.FocusEnd:Connect(function()
            Studio.Editor3D.UpdateGrid(Config.SnapTo,tonumber(Input.Text))
        end)
    end

    CreateOption({
        Icon = "Internal/Studio/TabIcons/MoveIcon.png",
        SnapTo = "GridSnap"
    })
    CreateOption({
        Icon = "Internal/Studio/TabIcons/RotIcon.png",
        SnapTo = "RotationSnap"
    })]]
    --Grid.Placeholder = tostring(Studio.Editor3D.GridSnap)
    --Text:SetFont(Studio.CurrentTheme.FontBold)
    return ButtonContainer
end