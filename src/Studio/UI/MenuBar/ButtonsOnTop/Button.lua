local Things = Runtime.Things
local Components = Studio.Components

return function(Args)
    local ButtonContainer = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(0.07,0.8),
        Text = Args.Name,
        ForegroundColor = Studio.Theme.Text,
        Alignment = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
    }

    if Args.Dropdown then
        local Dropdown = Components.AdvancedDropdown(Args.Dropdown)

        ButtonContainer.Clicked:Connect(function()
            Dropdown.Setup(ButtonContainer, Vector2.new(0,2))
            Dropdown.Toggle(not Dropdown.Visible)
        end)
    end

    ButtonContainer:SetFont("Assets/Fonts/Roboto/Roboto-Bold.ttf")
    
    return ButtonContainer
end