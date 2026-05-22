return function(FrameOption,Thing,Property)
    local MainText = Runtime.Things.Create("TextButton") {
        Text = Thing[Property],
        ForegroundColor = Studio.Theme.Text,
        BackgroundColor = Studio.Theme.Primary,
        Size = Pivot2D.FromScale(0.97,0.95),
        Position = Pivot2D.FromScale(0.5,0.5),
        Pivot = Vector2.new(0.5,0.5),
        Parent = FrameOption,
        CornerRadius=5
    }

    MainText.Clicked:Connect(function()
        local NewPath = FileDialog.OpenFileDialog("Choose 3D File for mesh path")
        Thing[Property] = NewFile
        if Property == "MeshPath" then Thing:LoadObject(NewPath) end
        MainText.Text = Thing[Property]
        -- Find a way to check if the select file is a 3D file, maybe using string.sub? 💃💃
    end)
end