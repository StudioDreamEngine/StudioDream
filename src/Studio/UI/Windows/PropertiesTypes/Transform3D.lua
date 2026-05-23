return function(FrameOption,Thing,Property)
    print(Thing[Property])
    Runtime.Things.Create("Text") {
        Text = tostring(Thing[Property]),
        ForegroundColor = Studio.Theme.Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = FrameOption
    }
end