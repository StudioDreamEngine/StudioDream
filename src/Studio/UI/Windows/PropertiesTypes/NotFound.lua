local Template = {}

function Template.Start(MainInfo)
    local self = {}
    --MainInfo.Connections

    for i,v in pairs(MainInfo.WillHandle) do
        -- Nothin, this is mostly for when the property will be set up
    end

    Runtime.Things.Create("Text") {
        Text = "WIP!",
        ForegroundColor = Studio.Theme.GetCurrentTheme().Text,
        BackgroundTransparency = 1,
        Size = Pivot2D.FromScale(1,1),
        Parent = MainInfo.Option,
        Alignment = Enum.Alignment.Center,
        Font = Studio.Theme.GetCurrentTheme().FontBold,
    }

    function self.Update()

    end

    return self
end

return Template