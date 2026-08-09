local Things = Runtime.Things

return function(Args)
    local ButtonContainer = Studio.Components.CreateStyle("ImageButton",{
        Size = Pivot2D.FromScale(1,1),
        SquareAxis = Enum.SquareAxis.Y,
        Resource = "Internal/Icons/SimplifiedLogo.png",
        ForegroundColor = "Text",
    })

    ButtonContainer.Clicked:Connect(Args.Function)

    return ButtonContainer
end