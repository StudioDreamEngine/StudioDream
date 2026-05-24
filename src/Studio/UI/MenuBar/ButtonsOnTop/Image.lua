local Things = Runtime.Things

return function(Args)
    local ButtonContainer = Things.Create("ImageButton") {
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Clicked = Args.OnClick,
        Image = "Assets/Icons/SimplifiedLogo.png",
    }

    return ButtonContainer
end