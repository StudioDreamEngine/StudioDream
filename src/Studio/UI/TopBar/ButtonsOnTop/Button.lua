local Things = Runtime.Things

return function(Args)
    local ButtonContainer = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(0.07,0.7),
        Text = Args.Name,
        ForegroundColor = Studio.Theme.Text,
        Align = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
    }
    ButtonContainer.Clicked:Connect(function()Args.OnClick(ButtonContainer)end)
    ButtonContainer:SetFont("Assets/Fonts/Roboto/Roboto-BoldItalic.ttf")
    return ButtonContainer
end