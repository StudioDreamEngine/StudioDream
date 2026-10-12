local Things = Runtime.Things

return function(Args)
    local Object = {}
    Object.ButtonContainer = Studio.Components.CreateStyle("TextButton",{
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Text = "",
        BackgroundTransparency = 0,
        BackgroundColor = "Secondary",
        CornerRadius = 5,
       -- OutlineSize = 1.5,
        --OutlineColor = Studio.CurrentTheme.Outline
    })
    Object.Image = Studio.Components.CreateStyle("Image2D",{
        Size = Pivot2D.FromScale(0.7,0.7),
        SquareAxis = Enum.SquareAxis.Y,
        Parent = Object.ButtonContainer,
        Name = "Showcase",
        Resource = "Internal/Studio/TabIcons/"..Args.Icon..".png",
        Pivot = Vector2.xAxis * .5,
        Position = Pivot2D.FromScale(0.5,0),
        ForegroundColor = "Text",
    })

    Object.Text = Studio.Components.CreateStyle("Text",{
        Parent = Object.ButtonContainer,
        Position = Pivot2D.FromScale(0.5,1),
        Pivot = Vector2.new(.5,1),
        Size = Pivot2D.FromScale(1,0.3),
        ForegroundColor = "Text",
        BackgroundTransparency = 1,
        Alignment = Enum.Alignment.TopLeft,
        Text = Args.Name,
        Name = "Titled",
    })
    Object.Text:SetFont(Studio.CurrentTheme.FontBold)

    Object.ButtonContainer.Clicked:Connect(function()
        Args.OnClick(Object)
    end)

    return Object.ButtonContainer
end