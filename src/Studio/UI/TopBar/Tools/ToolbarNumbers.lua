local Things = Runtime.Things

return function(Args,SingleTab)
    
    local ButtonContainer = Studio.Components.CreateStyle("Square",{
        Size = Pivot2D.FromScale(0.1,1),
        BackgroundTransparency = 0.5,
        CornerRadius = 5,
       -- OutlineSize = 1.5,
        --OutlineColor = Studio.CurrentTheme.Outline
    })

    Studio.Components.CreateStyle("ListLayout",{
        Parent = ButtonContainer,
        Padding = 5
    })

    function CreateOption(Config)
        local Grid = Studio.Components.CreateStyle("Square",{
        Parent = ButtonContainer,
        Size = Pivot2D.FromScale(1,0.4),
        ForegroundColor = Studio.CurrentTheme.Text,
        BackgroundTransparency = 0,
        BackgroundColor = Studio.CurrentTheme.Outline,
        CornerRadius = 5,
    })
    Studio.Components.CreateStyle("Image2D",{
        Parent = Grid,
        Position = Pivot2D.FromScale(0,0.5),
        Pivot = Vector2.new(0,0.5),
        Size = Pivot2D.FromScale(0.2,1),
        ForegroundColor = Studio.CurrentTheme.Text,
        ScaleType = Enum.ScaleType.LockAspect,
        BackgroundTransparency = 1,
        Resource = Config.Icon
    })
    local Input = Studio.Components.CreateStyle("TextInput",{
        Parent = Grid,
        Position = Pivot2D.FromScale(1,0.5),
        Pivot = Vector2.new(1,0.5),
        Size = Pivot2D.FromScale(0.8,1),
        ForegroundColor = Studio.CurrentTheme.Text,
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
    })
    --Grid.Placeholder = tostring(Studio.Editor3D.GridSnap)
    --Text:SetFont(Studio.CurrentTheme.FontBold)
    return ButtonContainer
end