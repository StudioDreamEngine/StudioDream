local Things = Runtime.Things

return function(Args)
    local ButtonContainer = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Text = "",
        Clicked = Args.OnClick,
        BackgroundTransparency = .5,
        BackgroundColor = Studio.Theme.CurrentTheme.Outline,
        CornerRadius = 5,
        OutlineSize = 1.5,
        OutlineColor = Studio.Theme.CurrentTheme.Outline
    }

    local Image = Things.Create("Image2D") {
        Size = Pivot2D.FromScale(0.7,0.7),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = ButtonContainer,
        Resource = "Internal/Studio/TabIcons/"..Args.Icon..".png",
        Pivot = Vector2.xAxis * .5,
        Position = Pivot2D.FromScale(0.5,0),
    }

    local Text = Things.Create("Text") {
        Parent = ButtonContainer,
        Position = Pivot2D.FromScale(0.5,1),
        Pivot = Vector2.new(.5,1),
        Size = Pivot2D.FromScale(1,0.3),
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundTransparency = 1,
        Alignment = Enum.Alignment.TopLeft,
        Text = Args.Name
    }
    Text:SetFont(Studio.Theme.CurrentTheme.FontBold)
    return ButtonContainer
end