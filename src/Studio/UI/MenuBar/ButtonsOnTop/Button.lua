local Things = Runtime.Things
local Components = Studio.Components
local OpendDropdown = nil

return function(Args)
    local ButtonContainer = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(0.07,0.8),
        Text = Args.Name,
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        Alignment = Vector2.new(0.5,0.5),
        BackgroundTransparency = 1,
    }

    if Args.Dropdown then
        local Dropdown = Components.AdvancedDropdown(Args.Dropdown)

        ButtonContainer.Clicked:Connect(function()
            if OpendDropdown then
                OpendDropdown.Toggle(false)
            end
            print("hello")
            Dropdown.Setup(ButtonContainer, Vector2.new(0,0.5))
            Dropdown.Toggle(not Dropdown.Visible)
            if Dropdown.Visible then
                OpendDropdown = Dropdown
            end
        end)
    end

    ButtonContainer:SetFont(Studio.Theme.GetCurrentTheme().FontBold)
    
    return ButtonContainer
end