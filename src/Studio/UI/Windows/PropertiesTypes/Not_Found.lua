return function(FrameOption)
        Runtime.Things.Create("Text") {
            Text = "Property Type not found! WIP!",
            ForegroundColor = Color.new(1,1,1),
            BackgroundTransparency = 1,
            Size = Pivot2D.FromScale(1,1),
            Parent = FrameOption
        }
    end