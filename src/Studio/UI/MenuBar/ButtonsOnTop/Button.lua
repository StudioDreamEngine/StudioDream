local Things = Runtime.Things
local Components = Studio.Components
local OpendDropdown = nil
local CurrentButtonPressed = nil
Runtime.InterfaceManager.OnClick:Connect(function()
    if CurrentButtonPressed and not CurrentButtonPressed.Hovering then
        OpendDropdown.Toggle(false)
    end
end)

return function(Args)
    local ButtonContainer = Things.Create("TextButton") {
        Size = Pivot2D.FromScale(0.05,0.9),
        Text = Args.Name,
        ForegroundColor = Studio.Theme.CurrentTheme.Text,
        BackgroundColor = Studio.Theme.CurrentTheme.Primary,
        Alignment = Vector2.new(0.5,0.5),
        HoverColorMultiplier = 2,
        BackgroundTransparency = 0.7,
    }

    if Args.Dropdown then
        local Dropdown = Components.AdvancedDropdown(Args.Dropdown)

        ButtonContainer.Clicked:Connect(function()
            if OpendDropdown and OpendDropdown ~= Dropdown then
                OpendDropdown.Toggle(false)
            end
            Dropdown.Setup(ButtonContainer, Vector2.new(0,0.5))
            Dropdown.Toggle(not Dropdown.Visible)
            if Dropdown.Visible then
                OpendDropdown = Dropdown
                CurrentButtonPressed = ButtonContainer
            end
        end)
    end

    ButtonContainer:SetFont(Studio.Theme.CurrentTheme.FontBold)
    
    return ButtonContainer
end