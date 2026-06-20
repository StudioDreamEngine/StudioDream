local FilePathd = {}
local Resources = Runtime.Resources

function FilePathd.Start(FrameOption,Thing,Property)

    local Attributes = Thing.Proxy.Attributes[Property] -- make attributes here do something like "only accept images/sounds/scenes" ect

    local MainText = Runtime.Things.Create("TextButton") {
        Text = Thing[Property] or "...",
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundColor = Studio.Theme.GetCurrentTheme().Primary,
        Size = Pivot2D.FromScale(0.97,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = FrameOption,
        TextScaled = true,
        CornerRadius=5
    }
    
    MainText.Clicked:Connect(function()
        local NewPath = Platform.OpenFileDialog("Select a resource for this thing.")

        if NewPath then
            local IdentifierWow = Resources.LoadOrCreateIdentifier(NewPath,"mp3")

            Thing:SetResource(IdentifierWow)
        end
    end)
end

return FilePathd