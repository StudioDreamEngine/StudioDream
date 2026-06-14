local Template = {}

function Template.Start(FrameOption) -- Scrapped for now
    Runtime.Things.Create("Text") {
        Text = "Property Type not found! WIP!",
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = FrameOption
    }
end

return Template