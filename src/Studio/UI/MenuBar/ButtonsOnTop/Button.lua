local OpendDropdown = nil

Runtime.InterfaceManager.OnClick:Connect(function()
    if (not Runtime.InterfaceManager.Hovering) and OpendDropdown then -- god why
        OpendDropdown.Toggle(false)
    end
end)

local Dropdowns = {}

return function(Args)
    local ButtonContainer = Studio.Components.CreateStyle("TextButton",{
        Size = Pivot2D.new(0,90,0.9,0),
        Text = Args.Name,
        ForegroundColor = "Text",
        BackgroundColor = Studio.CurrentTheme.Secondary,
        Alignment = Vector2.new(0.5,0.5),
        HoverColorMultiplier = 5,
        BackgroundTransparency = 0,
    })

    if Args.Function then
        ButtonContainer.Clicked:Connect(Args.Function)
    end

    if Args.Dropdown then
        local Dropdown = Studio.Components.DropdownPlus.new(Args.Dropdown,ButtonContainer)
        Dropdown.Toggle(false)

        table.insert(Dropdowns, Dropdown)
        
        ButtonContainer.Clicked:Connect(function()
            for _, OtherDropdown in pairs(Dropdowns) do
                if Dropdown ~= OtherDropdown then
                    OtherDropdown.Toggle(false)
                end
            end

            --Dropdown.Setup(ButtonContainer, Vector2.new(0,0.5))
            Dropdown.Toggle(not Dropdown.Visible)

            if Dropdown.Visible then
                Studio.AudioInternal.PlayAudio("Internal/DefaultSounds/Close.mp3",{})
                OpendDropdown = Dropdown
            else
                Studio.AudioInternal.PlayAudio("Internal/DefaultSounds/Open.mp3",{})
            end
        end)
    end

    ButtonContainer:SetFont(Studio.CurrentTheme.FontBold)
    
    return ButtonContainer
end