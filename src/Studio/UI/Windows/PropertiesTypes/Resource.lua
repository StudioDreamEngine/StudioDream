local FilePathd = {}

function FilePathd.Start(FrameOption,Thing,Property)
    local MainText = Runtime.Things.Create("TextButton") {
        Text = Thing[Property],
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
        local NewPath = Platform.OpenFileDialog("Select a resource for this object.")
        
        
    end)
end

return FilePathd