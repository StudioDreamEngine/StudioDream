local Things = Runtime.Things

return function(Args)
    local ButtonContainer = Studio.Components.CreateStyle("TextButton",{
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Text = "",
        Clicked = Args.OnClick,
        BackgroundTransparency = 0,
        BackgroundColor = Studio.CurrentTheme.Secondary,
        CornerRadius = 5,
       -- OutlineSize = 1.5,
        --OutlineColor = Studio.CurrentTheme.Outline
    })

    local Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(0.7,0.7),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = ButtonContainer,
        Resource = "Internal/Studio/TabIcons/"..Args.Icon..".png",
        Pivot = Vector2.xAxis * .5,
        Position = Pivot2D.FromScale(0.5,0),
        ForegroundColor = Studio.CurrentTheme.Text,
    })

    local Text = Studio.Components.CreateStyle("Text",{
        Parent = ButtonContainer,
        Position = Pivot2D.FromScale(0.5,1),
        Pivot = Vector2.new(.5,1),
        Size = Pivot2D.FromScale(1,0.3),
        ForegroundColor = Studio.CurrentTheme.Text,
        BackgroundTransparency = 1,
        Alignment = Enum.Alignment.TopLeft,
        Text = Args.Name
    })
    Text:SetFont(Studio.CurrentTheme.FontBold)
    return ButtonContainer
end