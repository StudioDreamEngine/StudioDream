return function(FrameOption,Thing,Property) 
    local Stringthing = Runtime.Things.Create("TextButton") {
        Size = Pivot2D.FromScale(1,1),
        Text = "Imatestthing",
        BackgroundTransparency = 1,
        ForegroundColor = Studio.Theme.Text2,
        Parent = FrameOption
    }

    Stringthing.Clicked:Connect(function()
        local Cloned = Thing:Clone()
    end)
end